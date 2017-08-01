require 'test_helper'

class CartTest < ActiveSupport::TestCase
  fixtures :products

  test "should create a new line item when adding a new product to cart" do
    cart = Cart.create
    cart.add_product(products(:ruby)).save!
    assert_equal cart.line_items.size, 1
    assert_equal cart.line_items[0].quantity, 1
    assert_equal cart.total_price.to_f, products(:ruby).price
  end

  test "should create two line items when adding two different products" do
    cart = Cart.create

    cart.add_product(products(:ruby)).save!
    cart.add_product(products(:two)).save!
    assert_equal cart.line_items.size, 2
    assert_equal cart.line_items[0].quantity, 1
    assert_equal cart.line_items[1].quantity, 1
    assert_equal cart.total_price, products(:ruby).price + products(:two).price
  end

  test "should update an existing line item when adding same product" do
    cart = Cart.create

    cart.add_product(products(:ruby)).save!
    cart.add_product(products(:ruby)).save!
    assert_equal cart.line_items.size, 1
    assert_equal cart.line_items[0].quantity, 2
    assert_equal cart.total_price, products(:ruby).price*2
  end

  test "should add a line item and update an existing line item" do
    cart = Cart.create

    cart.add_product(products(:ruby)).save!
    cart.add_product(products(:ruby)).save!
    cart.add_product(products(:two)).save!
    assert_equal cart.line_items.size, 2
    assert_equal cart.line_items[0].quantity, 2
    assert_equal cart.line_items[1].quantity, 1
    assert_equal cart.total_price, products(:ruby).price * 2 + products(:two).price
  end
end
