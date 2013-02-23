class LocationsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  NEARBY_DISTANCE_MI = 0.75

  def new
    @location = current_user.locations.build
  end

  def create
    @location = current_user.locations.build(params[:location])
    if @location.save
      redirect_to :action => "show", :id => @location.id
    else
      render 'new'
    end
  end

  def show
    @location = Location.find(params[:id])
    if user_signed_in?
      @tip = current_user.tips.new
      @tip.location = @location
    end
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
      render 'near'
    end
  end

end
