class TipsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @tip = current_user.tips.build :text => params[:tip][:text]
    @location = Location.find_by_id(params[:tip][:location_id])
    @tip.location = @location
    @tip.save!
    redirect_to @location
  end

  def destroy

  end

end
