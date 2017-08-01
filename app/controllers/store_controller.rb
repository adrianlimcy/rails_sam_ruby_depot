class StoreController < ApplicationController
  skip_before_action :authorize
  include CurrentCart
  before_action :set_cart
  def index
    if params[:set_locale]
      redirect_to store_index_url(locale: params[:set_locale])
    end
    increase_counter
    @products = Product.where(locale: I18n.locale)
    @products = @products.order(:title)
    @count = session[:counter]
    @time = Time.now
    if session[:counter] > 5
      @shown_message = "You have been here #{@count} " + 'time'.pluralize(@count) + "."
    end

  end
  def increase_counter
    if session[:counter].nil?
      session[:counter]=0
    end
      session[:counter]+=1
  end
end
