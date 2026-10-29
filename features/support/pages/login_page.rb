# frozen_string_literal: true

require_relative "base_page"

class LoginPage < BasePage
  def login_as(username, password)
    type("[data-test='username']", username)
    type("[data-test='password']", password)
    click("[data-test='login-button']")
  end
end
