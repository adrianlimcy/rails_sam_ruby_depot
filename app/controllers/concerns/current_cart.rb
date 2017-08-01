module CurrentCart
  private

  def set_cart
    @cart = Cart.find(session[:cart_id]) #session object
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end
end
