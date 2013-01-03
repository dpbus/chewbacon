class UsersController < ApplicationController
  before_filter :require_no_user, except: :show
  before_filter :require_user, only: :show

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      cookies[:auth_token] = @user.auth_token
      redirect_to root_url, notice: "Thanks for signing up!"
    else
      render 'new'
    end
  end
  
  def show
    @user = current_user
    @weigh_ins = current_user.weigh_ins
  end
end
