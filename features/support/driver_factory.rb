# frozen_string_literal: true

# Cria o driver conforme as variáveis de ambiente:
#   BROWSER=chrome|firefox (padrão: chrome)
#   HEADLESS=true          (sem interface gráfica)
class DriverFactory
  def self.build
    case ENV.fetch("BROWSER", "chrome").downcase
    when "chrome"  then chrome
    when "firefox" then firefox
    else raise ArgumentError, "BROWSER inválido. Use chrome ou firefox."
    end
  end

  def self.headless?
    ENV["HEADLESS"] == "true"
  end

  def self.chrome
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless=new") if headless?
    options.add_argument("--window-size=1366,768")
    # Necessários em runners de CI (containers)
    options.add_argument("--no-sandbox") if ENV["CI"]
    options.add_argument("--disable-dev-shm-usage") if ENV["CI"]
    # Evita pop-ups do gerenciador de senhas que bloqueiam cliques
    options.add_preference("credentials_enable_service", false)
    options.add_preference("profile.password_manager_enabled", false)
    options.add_preference("profile.password_manager_leak_detection", false)
    Selenium::WebDriver.for(:chrome, options: options)
  end

  def self.firefox
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument("-headless") if headless?
    Selenium::WebDriver.for(:firefox, options: options)
  end
end
