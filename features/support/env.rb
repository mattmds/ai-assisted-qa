# frozen_string_literal: true

require "yaml"
require "fileutils"
require "selenium-webdriver"
require "rspec/expectations"

# Configuração global (ambiente, URL e pasta de relatórios).
module Config
  ENVIRONMENTS = YAML.load_file(File.expand_path("../../config/environments.yml", __dir__))

  def self.environment
    ENV.fetch("TEST_ENV", "saucedemo")
  end

  def self.base_url
    ENV.fetch("BASE_URL") { ENVIRONMENTS.fetch(environment).fetch("base_url") }
  end

  def self.reports_dir
    "reports"
  end
end

# Massa de dados de teste (features/support/data/users.yml).
module TestData
  USERS = YAML.load_file(File.expand_path("data/users.yml", __dir__))

  def self.user(key)
    USERS.fetch(key.to_s) { raise ArgumentError, "Usuário '#{key}' não existe em users.yml" }
  end
end

# Acesso aos Page Objects dentro dos steps (instância criada sob demanda).
module PageHelpers
  def base_page      = @base_page      ||= BasePage.new(@driver, @wait)
  def login_page     = @login_page     ||= LoginPage.new(@driver, @wait)
  def inventory_page = @inventory_page ||= InventoryPage.new(@driver, @wait)
  def cart_page      = @cart_page      ||= CartPage.new(@driver, @wait)
  def checkout_page  = @checkout_page  ||= CheckoutPage.new(@driver, @wait)
end

World(RSpec::Matchers)
World(PageHelpers)
