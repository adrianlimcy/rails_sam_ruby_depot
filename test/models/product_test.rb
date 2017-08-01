require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  #1
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid? #expect true due to no title, description, price or image_url
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end #5 assertions
  #2
  test "price must be positive" do
    product = Product.new(title: "My Book Title",
                          description: "yyy",
                          image_url: "zzz.jpg",
                          locale: 'en')
    product.price = -1
    assert product.invalid? #expect true due to less than 0.01
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]
    product.price = 0
    assert product.invalid? #expect true due to less than 0.01
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]
    product.price = 1 #expect true as bigger than 0.01
    assert product.valid?
  end #5 assertions

  def new_product(image_url)
    Product.new(title: "My Book Title",
                description: "yyy",
                price: 1,
                image_url: image_url,
                locale: 'en')
  end
  #3
  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
              http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more gred.gif.more }
    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end
  #4
  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "yyy",
                          price: 1,
                          image_url: "fred.gif")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end

  test "image_url must be unique" do
    product1 = Product.new(title: products(:ruby).title,
                          description: products(:ruby).description,
                          price: products(:ruby).price,
                          image_url: products(:ruby).image_url)
    product2 = Product.new(title: "Test",
                          description: "yyy",
                          price: 1,
                          image_url: products(:ruby).image_url)

    assert product2.invalid?
    assert_equal ["has already been taken"], product2.errors[:image_url]
  end

  test "price must be less than $50" do
    product = Product.new(title: "Test",
                          description: "yyy",
                          price: 80.00,
                          image_url: products(:ruby).image_url)
    assert product.invalid?
    assert_equal ["must be less than 50.0"], product.errors[:price]
  end
end
