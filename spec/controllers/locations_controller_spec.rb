require 'spec_helper'

describe LocationsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "returns http success" do
      post 'create'
      response.should be_success
    end
  end

  describe "GET 'index'" do
    it "populates @locations array with all locations" do
      location1 = FactoryGirl.create :location
      location2 = FactoryGirl.create :location
      get :index
      assigns(:locations).should == [location1, location2]
    end
  end

end
