# frozen_string_literal: true

Dado("tenho {int} item/itens no carrinho") do |quantidade|
  inventory_page.add_items(quantidade)
  inventory_page.open_cart
end

Dado("estou na etapa de informações do checkout") do
  cart_page.start_checkout
  expect(checkout_page.on_info_step?).to be(true)
end

Quando("preencho nome {string}, sobrenome {string} e CEP {string}") do |nome, sobrenome, cep|
  checkout_page.fill_info(first_name: nome, last_name: sobrenome, postal_code: cep)
end

Quando("continuo para o resumo") do
  checkout_page.continue
end

Quando("confirmo o pedido") do
  checkout_page.continue
  checkout_page.finish
end

Então("devo ver a mensagem {string}") do |mensagem|
  expect(checkout_page.success_message).to eq(mensagem)
end
