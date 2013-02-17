require 'spec_helper'

def sign_in_user
  user = FactoryGirl.create :user
  user.confirm!
  sign_in user
end

describe LocationsController do

  describe "GET 'new'" do
    context "when there is no user logged in" do
      it "redirects to login page" do
        get 'new'
        response.should redirect_to new_user_session_path
      end
    end
    context "when there is a user logged in" do
      it "returns http success" do
        sign_in_user
        get 'new'
        response.should be_success
      end
    end
  end

  describe "POST 'create'" do
    before do
      sign_in_user
    end
    it "returns http success" do
      post 'create'
      response.should be_success
    end
    context "with a valid location" do
      before do
        @count = Location.count
        post 'create', { location: FactoryGirl.attributes_for(:location) }
      end
      it "creates a new location" do
        Location.count.should == @count + 1
      end
      it "shows the newly created location" do
        response.should redirect_to Location.last
      end
    end
  end

  describe "GET 'near'" do
    before do
      location1 = FactoryGirl.create :location, description: "Le Bus Stop", latitude: 47.6202762479463, longitude: -122.303993513106, user_id: 12
      location2 = FactoryGirl.create :location, description: "el portal", latitude: 47.6196396566275, longitude: -122.302057587033, user_id: 12
      location3 = FactoryGirl.create :location, description: "Mac counter at macy's", latitude: 37.7869744260011, longitude: -122.406910526459, user_id: 12
    end
    context "when requesting json" do
      before do
        @request.env["HTTP_ACCEPT"] = "application/json"
        get :near, :latitude => "47.6187812537455", :longitude => "-122.302367052115"
      end
      it 'returns json' do
        response.should be_success
        response.content_type.should == "application/json"
      end
      describe "the response" do
        it "contains nearby locations but not far away ones" do
          response.body.should =~ /Le Bus Stop/
          response.body.should =~ /el portal/
          response.body.should_not =~ /Mac counter at macy's/
        end
      end
      context "without lat / long on query string" do
        it "returns an error" do
          get :near
          response.should_not be_success
        end
      end
    end
    context "when requesting html" do
      before do
        @request.env["HTTP_ACCEPT"] = "text/html"
      end
      it 'returns html' do
        get :near
        response.should be_success
        response.content_type.should == "text/html"
      end
      context "with lat/long on the query string" do
        it "opens the map at that location" do
          get :near, :latitude => 60, :longitude => 70
          opts = assigns(:g4r_options)
          opts[:map_options][:center_latitude].should == "60"
          opts[:map_options][:center_longitude].should == "70"
        end
      end
      context "without lat/long on the query string" do
        it "detects user's position" do
          get :near
          opts = assigns(:g4r_options)
          opts[:map_options][:detect_location].should == true
          opts[:map_options][:center_on_user].should == true
        end
      end
    end
  end

end
