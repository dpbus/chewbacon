class GroupsController < ApplicationController
  def show
    @group = current_user.groups.find(params[:id])
    @weigh_ins = Array.new
    
    @group.users.each do |u|
      @weigh_ins << u.weigh_ins.all
    end
    puts @weigh_ins
  end
end
