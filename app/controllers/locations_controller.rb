class LocationsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]

  def new
    @location = current_user.locations.build
  end

  def create
    @location = current_user.locations.build(params[:location])
    if @location.save
      @location.reverse_geocode
      @location.save
      redirect_to :action => "show", :id => @location.id
    else
      render 'new'
    end
  end

  def show
    @location = Location.find(params[:id])
    @tips = Tip.where(:location_id => @location.id).order("created_at desc")
  end

  respond_to :json, :html
  def near
    center_point = false
    if params[:latitude] and params[:longitude]
      center_point = [params[:latitude], params[:longitude]]
    end
    if request.format.json?
      unless params[:latitude] and params[:longitude]
        render :text => "No location given", :status => 500
        return
      end
      @locations = Location.find_near(params[:latitude], params[:longitude], Location::NEARBY_DISTANCE_MI * 2)
      respond_with(@locations)
    else
      render 'near'
    end
  end

end
