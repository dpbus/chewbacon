class GroupsController < ApplicationController
  before_action :require_user
  before_action :require_admin, except: :show

  def new
    @group = Group.new
  end

  def show
    @group = current_user.admin ? Group.find(params[:id]) : current_user.groups.find(params[:id])
    @startd = params[:filter_start] || @group.start_date
    @endd = params[:filter_end] || @group.end_date
  end

  def create
    @group = Group.new(group_params)
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
    if @group.update(group_params)
      redirect_to @group, notice: "Group updated successfully!"
    else
      render :edit
    end
  end

  private

  def group_params
    params.require(:group).
      permit(:name, :start_date, :end_date, {user_ids: []})
  end
end
