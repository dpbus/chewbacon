class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  helper_method :current_user
  
  def authorize
    redirect_to login_url, alert: "Please sign in first." if current_user.nil?
  end
  
  def require_user
    unless current_user
      store_location
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      redirect_to root_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end
end
