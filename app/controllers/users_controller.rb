class UsersController < ApplicationController
  before_filter :require_no_user, only: [:new, :create]
  before_filter :require_user, only: [:show, :edit, :update]

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
    if ((params[:id] != current_user.id) && Group.shared_group(params[:id], current_user.id))
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    
    @weigh_ins = @user.weigh_ins.order(:date)
    @groups = @user.groups
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: "Account updated successfully!"
    else
      render :edit
    end
  end
end
