# frozen_string_literal: true

# Lê o relatório JSON do Cucumber, envia as falhas para a Gemini API
# e comenta a análise no Pull Request. Usa apenas a stdlib do Ruby.
#
# Uso: ruby scripts/analyze_failure.rb results.json
#
# Variáveis: GEMINI_API_KEY, GITHUB_TOKEN, REPO, PR_NUMBER, GEMINI_MODEL (opcional)

require "json"
require "net/http"
require "uri"

RESULTS_FILE = ARGV[0] || "results.json"
MAX_FAILURES = 5
MAX_ERROR_CHARS = 1500
MAX_OUTPUT_TOKENS = 2048
MAX_GEMINI_ATTEMPTS = 4
MODEL = ENV.fetch("GEMINI_MODEL", "gemini-3.6-flash")

def failures_from(report)
  report.flat_map do |feature|
    (feature["elements"] || []).filter_map do |scenario|
      failed = first_failed_step(scenario)
      format_failure(feature, scenario, failed) if failed
    end
  end
end

def first_failed_step(scenario)
  (scenario["steps"] || []).find { |step| step.dig("result", "status") == "failed" }
end

def format_failure(feature, scenario, failed)
  <<~TXT
    Feature: #{feature['name']} (#{feature['uri']})
    Cenário: #{scenario['name']} (linha #{scenario['line']})
    Step que falhou: #{failed['keyword']}#{failed['name']}
    Erro: #{failed.dig('result', 'error_message').to_s[0, MAX_ERROR_CHARS]}
  TXT
end

def build_request(uri, headers, payload)
  request = Net::HTTP::Post.new(uri, headers.merge("content-type" => "application/json"))
  request.body = JSON.generate(payload)
  request
end

def send_request(uri, request)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == "https"
  http.open_timeout = 10
  http.read_timeout = 60
  http.request(request)
end

def post_json(url, headers, payload)
  uri = URI(url)
  response = send_request(uri, build_request(uri, headers, payload))
  return response if response.is_a?(Net::HTTPSuccess)

  raise "HTTP #{response.code} de #{uri.host}: #{response.body.to_s[0, 500]}"
end

def build_prompt(failures)
  <<~PROMPT
    Você é um QA sênior. Analise as falhas de testes Cucumber (Ruby + Selenium) abaixo.
    Para cada uma, indique:
    1. Causa provável
    2. Se parece bug da aplicação, teste instável (flaky) ou problema de ambiente
    3. Próximo passo sugerido
    Seja objetivo, limite cada análise a 150 palavras e diga claramente quando não houver informação suficiente.

    #{failures.join("\n---\n")}
  PROMPT
end

def gemini_response(model_path, contents)
  post_json(
    "https://generativelanguage.googleapis.com/v1beta/models/#{model_path}:generateContent",
    { "x-goog-api-key" => ENV.fetch("GEMINI_API_KEY") },
    {
      contents: contents,
      generationConfig: { maxOutputTokens: MAX_OUTPUT_TOKENS }
    }
  )
end

def parse_gemini_response(response)
  data = JSON.parse(response.body)
  candidate = data.dig("candidates", 0)
  raise "Gemini não retornou uma resposta candidata." unless candidate

  text = candidate.dig("content", "parts")&.filter_map { |part| part["text"] }&.join("\n")
  raise "Gemini não retornou texto para análise." if text.to_s.empty?

  [candidate, text]
end

def append_continuation(contents, candidate)
  contents << candidate.fetch("content")
  contents << {
    role: "user",
    parts: [{ text: "Continue exatamente de onde parou, sem repetir o texto já produzido." }]
  }
end

def analyze_with_gemini(failures)
  model_path = URI.encode_www_form_component(MODEL)
  contents = [{ role: "user", parts: [{ text: build_prompt(failures) }] }]
  analysis = []

  MAX_GEMINI_ATTEMPTS.times do |attempt|
    candidate, text = parse_gemini_response(gemini_response(model_path, contents))
    analysis << text
    break unless candidate["finishReason"] == "MAX_TOKENS"
    raise "Análise excedeu o limite de continuações do Gemini." if attempt == MAX_GEMINI_ATTEMPTS - 1

    append_continuation(contents, candidate)
  end

  analysis.join("\n")
end

def comment_on_pull_request(body)
  post_json(
    "https://api.github.com/repos/#{ENV.fetch('REPO')}/issues/#{ENV.fetch('PR_NUMBER')}/comments",
    {
      "authorization" => "Bearer #{ENV.fetch('GITHUB_TOKEN')}",
      "accept" => "application/vnd.github+json",
      "user-agent" => "ai-assisted-qa"
    },
    { body: body }
  )
end

def main
  return puts("GEMINI_API_KEY ausente: análise por IA ignorada.") if ENV["GEMINI_API_KEY"].to_s.empty?
  return puts("results.json não encontrado.") unless File.exist?(RESULTS_FILE)

  failures = failures_from(JSON.parse(File.read(RESULTS_FILE))).first(MAX_FAILURES)
  return puts("Nenhuma falha encontrada.") if failures.empty?

  analysis = analyze_with_gemini(failures)
  comment_on_pull_request("### 🤖 Análise de falhas (gerada por IA, requer revisão humana)\n\n#{analysis}")
rescue StandardError => e
  # A análise é opcional: nunca quebra o pipeline.
  warn "Falha ao analisar com IA: #{e.message}"
end

main
