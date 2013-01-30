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

  describe "GET 'near'" do
    before do
      location1 = FactoryGirl.create :location
      location2 = FactoryGirl.create :location
    end
    context "when requesting json" do
      it 'returns json' do
        @request.env["HTTP_ACCEPT"] = "application/json"
        get :near, :latitude => "60", :longitude => "70"
        response.should be_success
        response.content_type.should == "application/json"
      end
    end
    context "when requesting html" do
      it 'returns html' do
        @request.env["HTTP_ACCEPT"] = "text/html"
        get :near, :latitude => "60", :longitude => "70"
        response.should be_success
        response.content_type.should == "text/html"
      end
    end
  end

end
