class AdminController < ApplicationController
  before_filter :authenticate_admin

  def locations
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
