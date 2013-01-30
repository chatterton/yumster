class LocationsController < ApplicationController
  include LocationsHelper

  def index
    @locations = Location.find :all
  end

  def new
    @location = Location.new
    @g4r_options = gmaps4rails_detect
  end

  def create
    @location = Location.new(params[:location])
    if @location.save
      index
      render 'index'
    else
      @g4r_options = gmaps4rails_detect
      render 'new'
    end
  end

  def show
    @location = Location.find(params[:id])
    @g4r_options = gmaps4rails_location(@location)
  end

  respond_to :json, :html
  def near
    if(request.format.json?)
      center_point = [params[:latitude] ||= 0, params[:longitude] ||= 0]
      box = Geocoder::Calculations.bounding_box(center_point, NEARBY_DISTANCE_MI)
      @locations = Location.within_bounding_box(box)
      respond_with(@locations)
    else
      @g4r_options = gmaps4rails_detect_wide
      render 'near'
    end
  end

end
