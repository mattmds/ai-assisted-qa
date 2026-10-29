# Geração de cenários Gherkin com IA

## Contexto

Fluxo de checkout do SauceDemo. Objetivo: reduzir o tempo de escrita de cenários sem perder cobertura de casos de borda.

## Ferramenta

- Claude (chat) para a geração inicial
- Revisão e ajustes manuais antes de qualquer commit

## Prompt utilizado

Versão completa em [`prompts/gherkin-from-user-story.md`](./prompts/gherkin-from-user-story.md).

> Você é um QA sênior. Com base na user story abaixo, gere cenários Gherkin (pt-BR) cobrindo caminho feliz, validações de campos obrigatórios, valores limite e erros de negócio. Não invente funcionalidades que não estejam descritas.
>
> User story: "Como cliente, quero finalizar a compra informando nome, sobrenome e CEP para receber meu pedido."
> User story: "Como cliente, acesso o site https://www.saucedemo.com/ com usuário "standard", ao chegar na página "inventory" seleciono um item da lista para adicionar ao carrinho"

## O que a IA gerou

> Exemplo: 

- 9 cenários no total
- Boa cobertura de: caminho feliz, presença e nome de itens e comparação item lista e carrinho

## Revisão humana

| Resultado                  | Qtde | Observação |
|----------------------------|------|------------|
| Aproveitados sem alteração | 8 |               |
| Aproveitados com ajuste    | 4 | Asserts genéricos; troquei por validação de mensagem exata |
| Descartados                | 2 | Cenários de cupom de desconto: funcionalidade inexistente na aplicação e cenários redundantes |

## Onde a IA errou

- Assumiu uma funcionalidade que não existe (cupom de desconto)
- Escreveu steps acoplados à UI ("clico no botão azul")
- Não cobriu campos obrigatórios individualmente até eu pedir explicitamente
- Repetia o login em cada cenário em vez de usar `Contexto` (Background)

## Exemplo: antes e depois

**Gerado pela IA**

```gherkin
Cenário: Finalizar compra com sucesso
  Dado que estou na página de checkout
  Quando clico no botão verde "Continue"
  Então vejo uma mensagem de sucesso
```

**Após revisão** (arquivo [`features/checkout.feature`](../../features/checkout.feature))

```gherkin
Contexto:
  Dado que estou autenticado como o usuário "standard"
  E tenho 1 item no carrinho
  E estou na etapa de informações do checkout

Cenário: Finalizar compra com dados válidos
  Quando preencho nome "Maria", sobrenome "Silva" e CEP "37500-000"
  E confirmo o pedido
  Então devo ver a mensagem "Thank you for your order!"
```

Mudanças: pré-condições movidas para `Contexto`, step desacoplado da cor do botão, dados de teste definidos e assert com mensagem exata.

## Aprendizados

- Incluir "não invente funcionalidades" no prompt reduziu alucinações na segunda iteração
- Fornecer a lista de campos e as regras de validação melhora muito a cobertura
- Pedir valores limite explicitamente gera casos que eu poderia deixar passar

## Resultado

> Exemplo: 

- Tempo para escrever os cenários: ~2h manual → ~40min com IA + revisão
- Cobertura: +3 casos de borda identificados

## Arquivos relacionados

- [`features/checkout.feature`](../../features/checkout.feature)
- [`features/step_definitions/checkout_steps.rb`](../../features/step_definitions/checkout_steps.rb)
