# frozen_string_literal: true

require_relative "base_page"

class CartPage < BasePage
  CART_LIST  = { css: '[data-test="cart-list"]' }.freeze
  ITEM_NAMES = { css: '[data-test="inventory-item-name"]' }.freeze
  CART_CHECKOUT = { css: '[data-test="checkout"]' }.freeze

  def wait_until_loaded
    element(CART_LIST)
  end

  def item_names
    wait_until_loaded
    elements(ITEM_NAMES).map(&:text)
  end

  def contains_item?(item_name)
    item_names.include?(item_name)
  end

  def start_checkout
    click(CART_CHECKOUT)
  end
end
