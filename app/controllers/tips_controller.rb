class TipsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @location = Location.find_by_id(params[:tip][:location_id])
    redirect_to @location
  end

  def destroy

  end

end
