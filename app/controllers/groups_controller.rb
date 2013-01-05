class GroupsController < ApplicationController
  before_filter :require_user
  before_filter :require_admin, except: :show
  
  def new
    @group = Group.new
  end
  
  def show
    @group = current_user.groups.find(params[:id])
  end
  
  def create
    @group = Group.new(params[:group])
    if @group.save
      redirect_to group_url(@group), notice: "Group created successfully!"
    else
      render :new
    end
  end
  
  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      redirect_to @group, notice: "Group updated successfully!"
    else
      render :edit
    end
  end
end
