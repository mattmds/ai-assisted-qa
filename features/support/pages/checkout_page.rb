# frozen_string_literal: true

require_relative "base_page"

class CheckoutPage < BasePage
  def on_info_step?
    @wait.until { @driver.current_url.include?("checkout-step-one") }
  end

  def fill_info(first_name:, last_name:, postal_code:)
    type("[data-test='firstName']", first_name)
    type("[data-test='lastName']", last_name)
    type("[data-test='postalCode']", postal_code)
  end

  def continue
    click("[data-test='continue']")
  end

  def finish
    click("[data-test='finish']")
  end

  def success_message
    text_of("[data-test='complete-header']")
  end
end
