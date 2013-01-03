class GroupsController < ApplicationController
  def show
    @group = current_user.groups.find(params[:id])
  end
end
