class LocationsController < ApplicationController
  def index
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new
    render 'new'
  end

  def show
    @location = Location.find(params[:id])
  end

end
