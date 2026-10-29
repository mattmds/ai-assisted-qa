# frozen_string_literal: true

Quando("faço login com o usuário {string}") do |tipo|
  user = TestData.user(tipo)
  login_page.login_as(user.fetch("username"), user.fetch("password"))
end

Quando("tento fazer login com usuário {string} e senha {string}") do |usuario, senha|
  login_page.login_as(usuario, senha)
end

Então("devo ver a página de produtos") do
  expect(inventory_page.title).to eq("Products")
end
