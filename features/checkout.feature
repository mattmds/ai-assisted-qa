# language: pt
@checkout
Funcionalidade: Checkout

  Contexto:
    Dado que estou autenticado como o usuário "standard"
    E tenho 1 item no carrinho
    E estou na etapa de informações do checkout

  @checkout_1 @smoke
  Cenário: Finalizar compra com dados válidos
    Quando preencho nome "Maria", sobrenome "Silva" e CEP "37500-000"
    E confirmo o pedido
    Então devo ver a mensagem "Thank you for your order!"

  @checkout_1 @smoke
  Esquema do Cenário: Finalizar compra com dados inválidos
    Quando preencho nome "<nome>", sobrenome "<sobrenome>" e CEP "<cep>"
    E continuo para o resumo
    Então devo ver o erro "<erro>"

    Exemplos:
      | nome  | sobrenome | cep       | erro                          |
      |       | Silva     | 37500-000 | Error: First Name is required |
      | Maria |           | 37500-000 | Error: Last Name is required  |
      | Maria | Silva     |           | Error: Postal Code is required |
