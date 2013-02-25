class TipsController < ApplicationController
  before_filter :authenticate_user!

  def create
    tip = current_user.tips.build :text => params[:tip][:text]
    location = Location.find_by_id(params[:tip][:location_id])
    tip.location = location
    tip.save!
    redirect_to location
  end

  def destroy
    tip = current_user.tips.find_by_id(params[:id])
    if tip
      tip.destroy
      redirect_to tip.location
    else
      render :status => :forbidden, :text => "Not allowed"
    end
  end

end
