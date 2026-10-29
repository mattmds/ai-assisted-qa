# frozen_string_literal: true

# Base dos Page Objects: esperas explícitas e ações comuns.
class BasePage
  ERROR_SELECTOR = "[data-test='error']"

  def initialize(driver, wait)
    @driver = driver
    @wait = wait
  end

  def visit(path = "")
    @driver.get("#{Config.base_url}#{path}")
  end

  def error_message
    text_of(ERROR_SELECTOR)
  end

  private

  def by(locator)
    locator.is_a?(Hash) ? locator : { css: locator }
  end

  # Aguarda o elemento existir e estar visível (sem sleep).
  def element(locator)
    loc = by(locator)
    @wait.until do
      found = @driver.find_element(loc)
      found if found.displayed?
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      nil
    end
  rescue Selenium::WebDriver::Error::TimeoutError => e
    raise "Elemento '#{loc.inspect}' não encontrado ou não visível: #{e.message}"
  end

  def elements(locator)
    @driver.find_elements(by(locator))
  end

  # Literal XPath seguro para textos com aspas
  def xpath_literal(text)
    return "'#{text}'" unless text.include?("'")
    return "\"#{text}\"" unless text.include?('"')

    "concat('#{text.split("'", -1).join(%q(', "'", '))}')"
  end

  def present?(locator)
    elements(locator).any?
  end

  def click(locator)
    loc = by(locator)
    @wait.until do
      found = @driver.find_element(loc)
      next unless found.displayed? && found.enabled?

      found.click
      true
    rescue Selenium::WebDriver::Error::StaleElementReferenceError,
           Selenium::WebDriver::Error::ElementClickInterceptedError,
           Selenium::WebDriver::Error::ElementNotInteractableError
      false
    end
  rescue Selenium::WebDriver::Error::TimeoutError => e
    raise e.class, "Não foi possível clicar em: #{loc.inspect} (#{e.message})"
  end

  def type(locator, text)
    field = element(locator)
    field.clear
    field.send_keys(text.to_s) unless text.to_s.empty?
  end

  def text_of(locator)
    element(locator).text
  end
end
