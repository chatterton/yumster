require 'spec_helper'

describe AdminController do

  def sign_in_admin
    user = sign_in_user
    user.admin = true
    user.save
    return user
  end

  describe "GET 'locations'" do
    context "when nobody is logged in" do
      it "returns a 404" do
        get 'locations'
        response.response_code.should == 404
      end
    end
    context "when a user without the admin flag is logged in" do
      it "returns a 404" do
        sign_in_user
        get 'locations'
        response.response_code.should == 404
      end
    end
    context "when an admin is logged in" do
      before do
        sign_in_admin
        Location.stub(:find_unapproved) { ["foo"] }
      end
      it "returns http success" do
        get 'locations'
        response.should be_success
      end
      it "assigns @locations with all unapproved locations" do
        get 'locations'
        assigns(:locations).should == ["foo"]
      end
    end
  end

  describe "put 'locations/:id/approve'" do
    before do
      sign_in_admin
      @location = FactoryGirl.create :location
      @location.approved = false
      @location.save
      put :approve, :id => @location.id
    end
    it 'should redirect to /admin/locations' do
      response.should redirect_to admin_locations_path
    end
    it 'should set the location to approved' do
      loc = Location.find(@location.id)
      loc.approved.should == true
    end
  end

  describe 'get admin/home' do
    before do
      sign_in_admin
    end
    it 'shows the admin home page' do
      get 'home'
      response.should be_success
    end
  end

  describe 'get admin/users' do
    before do
      sign_in_admin
      FactoryGirl.create :user
      get 'users'
    end
    it 'shows the users page' do
      response.should render_template("users")
    end
    it 'sets the users variable' do
      assigns(:users).should_not be_nil
    end
  end

  describe 'get admin/all_locations' do
    before do
      sign_in_admin
      FactoryGirl.create :user
      get 'all_locations'
    end
    it 'shows the all_locations page' do
      response.should render_template("all_locations")
    end
    it 'sets the all_locations variable' do
      assigns(:locations).should_not be_nil
    end
  end

end
