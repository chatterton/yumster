class LocationsController < ApplicationController

  def new
    if user_signed_in?
      @location = current_user.locations.build
    else
      @location = Location.new
    end
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
    if request.format.json?
      unless params[:lat] and params[:lng]
        render :text => "No location given", :status => 500
        return
      end
      begin
        @locations = Location.find_near(params[:lat], params[:lng], params[:span])
      rescue Exception => e
        render :text => e.message, :status => 500
        return
      end
      render :json => @locations.to_json(:only => [:id, :description, :latitude, :longitude, :category, :tips_count])
    else
      render 'near'
    end
  end

end
