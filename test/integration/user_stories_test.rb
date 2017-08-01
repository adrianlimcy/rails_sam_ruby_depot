require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  fixtures :orders
  include ActiveJob::TestHelper

  #A user goes to the store index page. He selects a product, adding it to his cart. he
  #then checks out, filling in his details on the checkout form. When he submits, an
  #order is created in the database containing his information, along with a single line
  #item corresponding to the product he added to his cart. Once the order has been
  #received, an email is sent confirming the purchase

  test "buying a product" do
    start_order_count = Order.count
    ruby_book = products(:ruby)
    #index page
    get "/"
    assert_response :success
    assert_select 'h1', "Your Pragmatic Catalog"
    #adding a line item
    post '/line_items', params: { product_id: ruby_book.id}, xhr: true
    assert_response :success
    #line item gets added into cart
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product
    #insert order
    get "/orders/new"
    assert_response :success
    assert_select 'legend', 'Please Enter Details'
    #make sure mail works with perform_enqueued_jobs
    perform_enqueued_jobs do
      post "/orders", params: {
        order: {
          name: "Dave Thomas",
          address: "123 The Street",
          email: "dave@example.com",
          pay_type_id: PayType.find_by(name: "Check").id
        }
      }
      follow_redirect!
      assert_response :success
      assert_select 'h1', "Your Pragmatic Catalog"
      #make sure cart is empty
      cart = Cart.find(session[:cart_id])
      assert_equal 0, cart.line_items.size
      #make sure order is created
      assert_equal start_order_count + 1, Order.count
      order = Order.last
      #check order params
      assert_equal "Dave Thomas", order.name
      assert_equal "123 The Street", order.address
      assert_equal "dave@example.com", order.email
      assert_equal "Check", order.pay_type.name
      assert_equal 1, order.line_items.size
      line_item = order.line_items[0]
      assert_equal ruby_book, line_item.product
      #check mail
      mail = ActionMailer::Base.deliveries.last
      assert_equal ["dave@example.com"], mail.to
      assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
      assert_equal "Pragmatic Store Order Confirmation", mail.subject
    end
  end
  test "attempt to wrong order page sends an email to admin" do
    perform_enqueued_jobs do
      get "/orders/wibble"
      follow_redirect!
      assert_response :success
      assert_select 'h1', "Your Pragmatic Catalog"
      mail = ActionMailer::Base.deliveries.last
      assert_equal ["depot@example.com"], mail.to
      assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
      assert_equal "Order page, ActiveRecord::RecordNotFound", mail.subject
    end
  end
  test "sends shipped email when ship date is entered" do
    perform_enqueued_jobs do
      order = orders(:one)

      patch "/orders/#{order.id}", params: {
        order: {
          name: "Dave Thomas",
          address: "123 The Street",
          email: "dave@example.com",
          pay_type_id: PayType.find_by(name: "Check").id,
          ship_date: Time.now.to_date
        }
      }
      follow_redirect!
      assert_response :success
      assert_select 'strong', 'Name:'
      mail = ActionMailer::Base.deliveries.last
      assert_equal ["dave@example.com"], mail.to
      assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
      assert_equal "Pragmatic Store Order Shipped", mail.subject
    end
  end



end
