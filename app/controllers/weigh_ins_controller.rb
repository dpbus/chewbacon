class WeighInsController < ApplicationController
  before_filter :require_user
  
  def index
    @weigh_ins = WeighIn.all
  end
  
  def new
    @weigh_in = current_user.weigh_ins.new(date: Date.today)
  end
  
  def create
    @weigh_in = current_user.weigh_ins.new(params[:weigh_in])
    if @weigh_in.save
      redirect_to root_url, notice: "Weight saved!"
    else
      render :new
    end
  end
end
