class SessionsController < ApplicationController
  before_action :require_user, only: :destroy
  before_action :require_no_user, except: :destroy

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      redirect_to root_url, notice: "You are now signed in!"
    else
      flash.now.alert = "Incorrect email or password"
      render 'new'
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_url, notice: "You have been signed out."
  end
end
