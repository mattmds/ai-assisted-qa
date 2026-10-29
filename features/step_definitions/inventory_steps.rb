# frozen_string_literal: true

Quando("eu estiver na página de inventário") do
  inventory_page.wait_until_loaded
end

Quando("o carrinho está vazio") do
  total = inventory_page.cart_item_count
  expect(total).to eq(0), "Esperava o carrinho vazio, mas ele contém #{total} item(ns)"
end

# Listagem

Então("a lista deve exibir pelo menos um item") do
  total = inventory_page.item_names.size
  expect(total).to be >= 1, "Esperava ao menos 1 item no inventário, mas a lista exibiu #{total}"
end

Então("todos os itens devem possuir o prefixo {string}") do |prefixo|
  sem_prefixo = inventory_page.item_names_without_prefix(prefixo)
  expect(sem_prefixo).to eq([]), "Itens sem o prefixo '#{prefixo}': #{sem_prefixo.inspect}"
end

# Carrinho

Quando("adiciono o item {string} ao carrinho") do |item|
  inventory_page.add_to_cart(item)
end

Então("o carrinho deve conter o item {string}") do |item|
  inventory_page.open_cart
  expect(cart_page.contains_item?(item)).to be(true),
                                            "Esperava o item '#{item}' no carrinho, mas ele não foi encontrado"
end
