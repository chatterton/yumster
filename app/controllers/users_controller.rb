class UsersController < ApplicationController
  def show
    @user = User.where(:username => params[:username]).first
    render :file => "#{Rails.root}/public/404", :status => 404 unless @user
  end
end
