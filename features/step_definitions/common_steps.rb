# frozen_string_literal: true

Dado("que estou na página de login") do
  login_page.visit
end

Dado("que estou autenticado como o usuário {string}") do |tipo|
  user = TestData.user(tipo)
  login_page.visit
  login_page.login_as(user.fetch("username"), user.fetch("password"))
  expect(inventory_page.title).to eq("Products")
end

Então("devo ver o erro {string}") do |mensagem|
  expect(base_page.error_message).to eq(mensagem)
end
