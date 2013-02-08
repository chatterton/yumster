class LocationsController < ApplicationController
  include Gmaps4RailsHelper

  def index
    @locations = Location.find :all
  end

  def new
    @location = current_user.locations.build
    @g4r_options = gmaps4rails_detect
  end

  def create
    @location = current_user.locations.build(params[:location])
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
    center_point = false
    if params[:latitude] and params[:longitude]
      center_point = [params[:latitude], params[:longitude]]
    end
    if request.format.json?
      unless center_point
        render :text => "No location given", :status => 500
        return
      end
      box = Geocoder::Calculations.bounding_box(center_point, NEARBY_DISTANCE_MI)
      @locations = Location.within_bounding_box(box)
      respond_with(@locations)
    else
      if center_point
        @g4r_options = gmaps4rails_zoomto_wide(center_point[0], center_point[1])
      else
        @g4r_options = gmaps4rails_detect_wide
      end
      render 'near'
    end
  end

end
