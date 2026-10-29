# language: pt
@inventory
Funcionalidade: Inventory

  Contexto:
    Dado que estou autenticado como o usuário "standard"
    Quando eu estiver na página de inventário
    E o carrinho está vazio

  @inventory_1 @smoke
  Cenário: Listar itens disponíveis no inventário
    Então a lista deve exibir pelo menos um item

  @inventory_2 @smoke
  Cenário: Verificar se todos os itens possuem o prefixo Sauce Labs
    Então todos os itens devem possuir o prefixo "Sauce Labs"

  @inventory_3 @smoke
  Cenário: Adicionar um item ao carrinho (caminho feliz)
    Quando adiciono o item "Sauce Labs Backpack" ao carrinho
    Então o carrinho deve conter o item "Sauce Labs Backpack"