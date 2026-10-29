# Prompt: step definitions Ruby/Cucumber

## Quando usar
Depois que o `.feature` foi revisado, para gerar o esqueleto das step definitions e dos Page Objects.

## Prompt (versão 2)

```text
Você é um engenheiro de QA sênior em Ruby.

Gere step definitions Cucumber (Ruby) em pt-br e Page Objects em Selenium WebDriver
para o arquivo .feature abaixo.

Requisitos:
- Use Cucumber Expressions ({string}, {int}), não regex
- Page Objects herdando de BasePage, com seletores baseados em atributos estáveis (data-test, id); nunca em classes de estilo
- Esperas explícitas; NUNCA use sleep
- Nenhuma lógica de negócio nos steps: eles apenas delegam ao Page Object
- Asserts com rspec-expectations e mensagem exata, sem includes genéricos
- Não invente elementos de tela: se faltar informação sobre o HTML, liste o que precisa ser confirmado ao final

Convenções do projeto:
- Driver em @driver e wait em @wait (definidos em features/support/hooks.rb)
- Page Objects acessados por helpers (login_page, checkout_page...) definidos no World
- Idioma dos steps: pt-BR

Arquivo .feature:
<cole aqui>

HTML relevante (se houver):
<cole aqui>
```

## Histórico de versões

| Versão | Mudança | Efeito observado |
|---|---|---|
| 1 | Prompt simples, só com o .feature | `sleep`, seletores frágeis, lógica nos steps |
| 2 | Regras de seletor, espera explícita e Page Object | Código muito mais próximo do padrão do projeto |

## Checklist de revisão da saída

- [ ] Há algum `sleep`?
- [ ] Os seletores são estáveis?
- [ ] Os steps só delegam ao Page Object?
- [ ] Os asserts validam valores exatos?
- [ ] O código roda de verdade contra a aplicação?
