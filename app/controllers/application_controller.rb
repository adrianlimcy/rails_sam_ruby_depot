class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  before_action :authorize
  protect_from_forgery with: :exception

  protected
  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        I18n.locale = params[:locale]
      else
        flash.now[:notice] =
        "#{params[:locale]} translation is not available"
        logger.error flash.now["notice"]
      end
    end
  end

  def authorize
    if request.format != Mime[:html] #small letters html is important
      authenticate_or_request_with_http_basic ("Product Statistics") do |u , password|
        User.find_by(name: u).try(:authenticate, password)
      end

    else
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: "Please log in"
      end
    end
  end
end
