require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @update = {
      title: 'Loren Ipsum',
      description: 'Wibbles are fun!',
      image_url: 'lorem.jpg',
      price: 19.95,
      locale: 'en'
    }
  end
#1
  test "should get index" do
    get products_url
    assert_response :success
    assert_select '.list_description', minimum: 3
    assert_select 'dt', 'Programming Ruby 1.9'
  end
#2
  test "should get new" do
    get new_product_url
    assert_response :success
  end
#3
  test "should create product" do
    assert_difference('Product.count') do
      post products_url, params: { product: @update }
    end

    assert_redirected_to product_url(Product.last)
  end
#4
  test "should show product" do
    get product_url(@product)
    assert_response :success
  end
#5
  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end
#6
  test "should update product" do
    patch product_url(@product), params: { product: @update }
    assert_redirected_to product_url(@product)
  end
#7
  test "can't delete product in cart" do
    assert_difference('Product.count', 0) do
      delete product_url(products(:two))
    end
    assert_redirected_to products_url
  end
#8
  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete product_url(@product)
    end
    assert_redirected_to products_url
  end
end
