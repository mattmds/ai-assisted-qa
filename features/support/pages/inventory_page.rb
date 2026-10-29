# frozen_string_literal: true

require_relative "base_page"

class InventoryPage < BasePage
  TITLE          = "[data-test='title']"
  INVENTORY_LIST = "[data-test='inventory-list']"
  ITEM_NAMES     = "[data-test='inventory-item-name']"
  ADD_TO_CART    = "button[data-test^='add-to-cart']"
  CART_LINK      = "[data-test='shopping-cart-link']"
  CART_BADGE     = "[data-test='shopping-cart-badge']"

  def wait_until_loaded
    element(INVENTORY_LIST)
  end

  def title
    text_of(TITLE)
  end

  def item_names
    wait_until_loaded
    elements(ITEM_NAMES).map(&:text)
  end

  def item_names_without_prefix(prefix)
    item_names.reject { |name| name.start_with?(prefix) }
  end

  # Adiciona um produto específico pelo nome e espera o botão dele virar "remover".
  def add_to_cart(item_name)
    wait_until_loaded
    click(add_button_for(item_name))
    element(remove_button_for(item_name))
  end

  # Adiciona N produtos (sempre o primeiro disponível) e confirma o contador a cada clique.
  def add_items(quantity)
    quantity.times do |index|
      click(ADD_TO_CART)
      @wait.until { cart_item_count == index + 1 }
    end
  end

  def open_cart
    click(CART_LINK)
  end

  # Quantidade exibida no ícone do carrinho; 0 quando o contador não existe.
  # Leitura imediata (sem espera), segura para uso dentro de @wait.until.
  def cart_item_count
    badge = elements(CART_BADGE).first
    badge ? badge.text.to_i : 0
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    retry # o contador foi re-renderizado entre a busca e a leitura
  end

  private

  def item_xpath(item_name)
    "//*[@data-test='inventory-item']" \
      "[.//*[@data-test='inventory-item-name' and normalize-space(.)=#{xpath_literal(item_name)}]]"
  end

  def add_button_for(item_name)
    { xpath: "#{item_xpath(item_name)}//button[starts-with(@data-test,'add-to-cart')]" }
  end

  def remove_button_for(item_name)
    { xpath: "#{item_xpath(item_name)}//button[starts-with(@data-test,'remove')]" }
  end
end
