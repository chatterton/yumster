class AdminController < ApplicationController
  before_filter :authenticate_admin

  def locations
    @locations = Location.find_unapproved
  end

  def approve
    @location = Location.find(params[:id])
    @location.approved = true
    @location.save
    redirect_to admin_locations_path
  end

  protected
  def authenticate_admin
    unless current_user and current_user.admin
      render :file => "#{Rails.root}/public/404", :status => :not_found, :formats => :html
      return false
    end
    return true
  end
end
