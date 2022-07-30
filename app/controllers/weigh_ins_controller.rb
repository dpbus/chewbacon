class WeighInsController < ApplicationController
  before_action :require_user

  def index
    @weigh_ins = WeighIn.all
  end

  def new
    @weigh_in = current_user.weigh_ins.new(date: Date.today)
  end

  def create
    @weigh_in = current_user.weigh_ins.new(weigh_in_params)
    if @weigh_in.save
      redirect_to root_url, notice: "Weight saved!"
    else
      render :new
    end
  end

  def destroy
    @weigh_in = current_user.weigh_ins.find(params[:id])
    @weigh_in.delete
    redirect_to current_user, notice: "Weigh-in deleted successfully."
  end

  def edit
    @weigh_in = current_user.weigh_ins.find(params[:id])
  end

  def update
    @weigh_in = current_user.weigh_ins.find(params[:id])
    if @weigh_in.update(weigh_in_params)
      redirect_to current_user, notice: "Weigh-in updated successfully."
    else
      render :edit
    end
  end

  private

  def weigh_in_params
    params.require(:weigh_in).permit(:date, :weight)
  end
end
