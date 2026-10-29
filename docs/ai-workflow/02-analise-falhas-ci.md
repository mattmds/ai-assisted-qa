# Análise de falhas no CI com IA

## Contexto

Quando um cenário Cucumber falha no GitHub Actions, investigar logs e stack trace consome tempo. Este fluxo envia o resumo da falha à Gemini API, que comenta no Pull Request com uma **hipótese de causa e próximos passos**.

> A análise é apenas informativa. Nenhuma correção é aplicada automaticamente e o resultado sempre passa por revisão humana.

## Fluxo

1. O Cucumber executa os cenários e gera `results.json` (`bundle exec cucumber -p ci`)
2. O workflow publica o relatório e os screenshots como artefatos
3. Em Pull Requests com falha, [`scripts/analyze_failure.rb`](../../scripts/analyze_failure.rb) localiza em cada cenário o primeiro step com status `failed` e extrai feature, cenário, step e mensagem de erro
4. O resumo (limitado a 5 falhas e 1500 caracteres por erro) é enviado ao modelo
5. A resposta é publicada como comentário no PR
6. Por último, o job falha se os testes falharam, então a análise nunca "esconde" uma falha

## Arquivos

| Arquivo | Função |
|---|---|
| [`.github/workflows/cucumber.yml`](../../.github/workflows/cucumber.yml) | Pipeline |
| [`scripts/analyze_failure.rb`](../../scripts/analyze_failure.rb) | Análise com IA (apenas stdlib do Ruby) |
| [`features/support/hooks.rb`](../../features/support/hooks.rb) | Screenshot em falha |
| [`config/cucumber.yml`](../../config/cucumber.yml) | Profile `ci` com saída JSON |

## Cuidados

- Nunca incluir tokens, senhas ou dados pessoais reais nos logs enviados
- A chave `GEMINI_API_KEY` fica em *Secrets* do repositório, nunca no código
- O modelo pode ser alterado pela variável `GEMINI_MODEL`; o padrão é `gemini-3.6-flash`
- A chamada à Gemini API usa a cota e os termos associados à conta Google configurada
- Sem a chave (ex.: PRs de forks) ou se a chamada falhar, o script só registra um aviso e o pipeline segue

## Onde a IA errou / limitações

- Exemplo: tratou `StaleElementReferenceError` como bug da aplicação quando era problema de sincronização
- Exemplo: sugeriu `sleep` em vez de espera explícita

## Resultado

> Exemplo: 

- Tempo médio de triagem por falha: ~20min → ~5min
- Hipótese correta em ~6 de 10 casos; nos demais serviu como ponto de partida
