# language: pt
# utf-8
@login
Funcionalidade: Login

  Contexto:
    Dado que estou na página de login

  @login_1 @smoke
  Cenário: Login com credenciais válidas
    Quando faço login com o usuário "standard"
    Então devo ver a página de produtos

  @login_2
  Cenário: Login com usuário bloqueado
    Quando faço login com o usuário "locked"
    Então devo ver o erro "Epic sadface: Sorry, this user has been locked out."

  @login_3 @smoke
  Esquema do Cenário: Login com campos obrigatórios vazios
    Quando tento fazer login com usuário "<usuario>" e senha "<senha>"
    Então devo ver o erro "<erro>"

    Exemplos:
      | usuario       | senha        | erro                               |
      |               | secret_sauce | Epic sadface: Username is required |
      | standard_user |              | Epic sadface: Password is required |
