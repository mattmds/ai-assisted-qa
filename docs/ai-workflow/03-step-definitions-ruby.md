# Step definitions em Ruby com apoio de IA

## Contexto

Dado um `.feature` já revisado, usei IA para gerar o esqueleto das step definitions e dos Page Objects em Ruby + Selenium WebDriver. O objetivo é ganhar tempo no código repetitivo, mantendo as boas práticas de código e o controle da qualidade dos seletores e das esperas.

## Prompt utilizado

Versão completa em [`prompts/step-definitions-ruby.md`](./prompts/step-definitions-ruby.md).

## O que a IA gerou (resumo)

- Step definitions com Cucumber Expressions
- Um Page Object para o checkout
- Código funcional na maior parte, mas com problemas de robustez

## Onde a IA errou

> Exemplo: ajuste conforme o que você observar na prática.

| Problema | Gerado pela IA | Após revisão |
|---|---|---|
| Sincronização | `sleep 3` entre as ações | Espera explícita (`Selenium::WebDriver::Wait`) em `BasePage` |
| Seletores | `.btn_action` (classe de estilo) | `[data-test='continue']` (atributo estável) |
| Lógica nos steps | Login e navegação repetidos dentro de cada step | Login em `Contexto`; steps delegam a Page Objects |
| Assert | `include("order")` | `eq("Thank you for your order!")` |
| Estrutura | Tudo em um arquivo | `BasePage` + uma classe por página |
| Idioma | `Given`, `When`, `Then`, mesmo passando a feature em pt-br | `Dado`, `Quando`, `Então` |

## Exemplo: antes e depois

**Gerado pela IA**

```ruby
Quando("preencho os dados e confirmo") do
  @driver.find_element(css: "#first-name").send_keys("Maria")
  @driver.find_element(css: "#last-name").send_keys("Silva")
  @driver.find_element(css: "#postal-code").send_keys("37500-000")
  sleep 3
  @driver.find_element(css: ".btn_action").click
end
```

**Após revisão**
```ruby
Quando("preencho nome {string}, sobrenome {string} e CEP {string}") do |nome, sobrenome, cep|
  checkout_page.fill_info(first_name: nome, last_name: sobrenome, postal_code: cep)
end

Quando("confirmo o pedido") do
  checkout_page.continue
  checkout_page.finish
end
```

- [`features/step_definitions/checkout_steps.rb`](../../features/step_definitions/checkout_steps.rb)
- [`features/support/pages/base_page.rb`](../../features/support/pages/base_page.rb)
- [`features/support/pages/checkout_page.rb`](../../features/support/pages/checkout_page.rb)

## Aprendizados

- Pedir "sem sleep, com esperas explícitas" no prompt elimina boa parte dos problemas
- Informar a convenção de seletores do projeto (ex.: `data-test`) melhora muito a qualidade
- A IA tende a misturar responsabilidades; revisar a separação entre steps e Page Objects é essencial
- Adicionar `em pt-br` no prompt de geração dos steps

## Resultado

> Exemplo: substitua pelos seus números reais.

- Tempo para montar steps e Page Objects de uma feature: ~1h30 → ~35min com IA + revisão
