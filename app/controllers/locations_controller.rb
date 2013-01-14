class LocationsController < ApplicationController
  def index
  end

  def new
  end

  def show
    @location = Location.find(params[:id])
  end

end
