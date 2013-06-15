class AdminController < ApplicationController
  before_filter :authenticate_admin

  def home
  end

  def locations
    @locations = Location.find_unapproved
  end

  def approve
    @location = Location.find(params[:id])
    @location.approved = true
    @location.save
    redirect_to admin_locations_path
  end

  def users
    @users = User.all :order => "id desc"
  end

  def all_locations
    @locations = Location.all :order => "id desc", :include => :user
  end

  protected

  def authenticate_admin
    unless current_user && current_user.admin
      render :file => "#{Rails.root}/public/404", :status => :not_found, :formats => :html, :layout => false
    end
  end
end
