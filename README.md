# ai-assisted-qa

[![Cucumber](https://github.com/mattmds/ai-assited-qa/actions/workflows/cucumber.yml/badge.svg)](https://github.com/mattmds/ai-assited-qa/actions/workflows/cucumber.yml)
![Ruby 3.3.0](https://img.shields.io/badge/Ruby-3.3.0-CC342D?logo=ruby&logoColor=white)
![Gemini API](https://img.shields.io/badge/Gemini_API-Google-8E75B2?logo=googlegemini&logoColor=white)

Projeto de automação de testes E2E em **Ruby + Cucumber + Selenium WebDriver** que demonstra o **uso prático de IA no ciclo de QA**: geração de cenários, geração de step definitions e análise de falhas no CI, sempre com revisão humana.

Aplicação testada: [SauceDemo](https://www.saucedemo.com) (site público de demonstração).

## Stack

- Ruby 3.3, Cucumber (Gherkin em pt-BR), Selenium WebDriver, RSpec Expectations
- GitHub Actions (execução headless, artefatos e análise de falhas por IA)
- Rubocop (padronização de código)

## Estrutura

```
.
├── .github/workflows/cucumber.yml   # pipeline
├── config/
│   ├── cucumber.yml                 # profiles: default, smoke, ci
│   └── environments.yml             # URLs por ambiente
├── features/
│   ├── login.feature
│   ├── checkout.feature
│   ├── step_definitions/            # steps finos: delegam aos Page Objects
│   └── support/
│       ├── env.rb                   # Config, TestData e World
│       ├── hooks.rb                 # Before/After (driver e screenshot em falha)
│       ├── driver_factory.rb        # Chrome/Firefox, headless
│       ├── data/users.yml           # massa de dados
│       └── pages/                   # Page Objects (BasePage + páginas)
├── scripts/analyze_failure.rb       # análise de falhas com IA
├── docs/ai-workflow/                # como a IA é usada, com prompts e resultados
└── reports/                         # screenshots (ignorado no git)
```

## Como rodar

Pré-requisitos: Ruby 3.3+ e Google Chrome (ou Firefox) instalado.

```bash
bundle install

bundle exec cucumber                      # todos os cenários
bundle exec cucumber -p smoke             # apenas @smoke
HEADLESS=true bundle exec cucumber -p ci  # headless + results.json
BROWSER=firefox bundle exec cucumber      # outro navegador
bundle exec cucumber features/login.feature
bundle exec rubocop                       # lint
```

### Variáveis de ambiente

| Variável | Padrão | Descrição |
|---|---|---|
| `BROWSER` | `chrome` | `chrome` ou `firefox` |
| `HEADLESS` | `false` | `true` para rodar sem interface |
| `TEST_ENV` | `saucedemo` | Ambiente definido em `config/environments.yml` |
| `BASE_URL` | (do ambiente) | Sobrescreve a URL base |

### Tags

`@smoke`, `@login`, `@checkout`, `@wip` (cenários em desenvolvimento são ignorados por padrão).

## Padrões adotados

- **Page Object** com seletores estáveis (`data-test`), nunca classes de estilo
- **Esperas explícitas**, sem `sleep`
- **Steps declarativos e finos**: sem lógica de negócio, só delegam à página e fazem o assert
- **Massa de dados** fora dos steps (`features/support/data`)
- **Screenshot automático** em caso de falha, publicado como artefato no CI

## IA neste projeto

Documentação completa em [`docs/ai-workflow`](./docs/ai-workflow/README.md):

1. [Geração de cenários Gherkin](./docs/ai-workflow/01-geracao-cenarios.md)
2. [Análise de falhas no CI](./docs/ai-workflow/02-analise-falhas-ci.md)
3. [Step definitions com apoio de IA](./docs/ai-workflow/03-step-definitions-ruby.md)

### CI e Quality Gate da branch principal

O fluxo recomendado é desenvolver em uma branch auxiliar e integrar as alterações à `main` por meio de um Pull Request:

1. Ao abrir um Pull Request para `main`, o GitHub Actions executa os testes regressivos. 
2. O perfil `ci` executa todos os cenários marcados com `@smoke` e gera `results.json`.
3. O relatório JSON e os screenshots são publicados como artefatos do workflow.
4. Se os testes falharem em um Pull Request e `GEMINI_API_KEY` estiver disponível, o script envia um resumo das falhas à Gemini API e publica a análise como comentário no Pull Request.
5. O job termina como falho quando os testes falham. Com o check `cucumber` configurado como obrigatório nas regras da branch `main`, o GitHub bloqueia o merge até que a verificação passe.

Quality Gate: Um push para a branch `integrar-gemini-api` sem Pull Request aberto não inicia o workflow. O evento `pull_request` executa os testes regressivos ao abrir o PR e quando ele recebe novos commits. Como a regra da branch principal exige PR e o check `cucumber`, o fluxo normal para atualizar a `main` é por meio de um PR aprovado pelos testes. O workflow também pode ser iniciado manualmente (`workflow_dispatch`).

### Configurar a análise de falhas com Gemini

1. Crie uma chave no [Google AI Studio](https://aistudio.google.com/apikey).
2. No GitHub, abra *Settings → Secrets and variables → Actions → New repository secret*.
3. Crie o secret `GEMINI_API_KEY` e cole nele a chave. Não a adicione ao código.
4. Abra um Pull Request: se algum cenário falhar, o workflow tentará publicar um comentário com a análise.
5. Opcional: em *Variables*, crie `GEMINI_MODEL` para escolher outro modelo. O padrão é `gemini-3.6-flash`.

O `GITHUB_TOKEN` é fornecido automaticamente pelo GitHub Actions. Sem `GEMINI_API_KEY` (por exemplo, em PRs de forks), a análise por IA é ignorada; os testes ainda rodam e podem falhar normalmente.

## Autor

Matheus Mendes · [LinkedIn](https://linkedin.com/in/matheus-mendes-qa) · [GitHub](https://github.com/mattmds)
