require 'spec_helper'

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
        Geocoder.configure(:lookup => :test)
        Geocoder::Lookup::Test.add_stub(
          [1.5, 1.8],
          [{
            'address' => 'Las Vegas, NV',
          }]
        )
        @count = Location.count
        post 'create', { location: FactoryGirl.attributes_for(:location, :latitude => 1.5, :longitude => 1.8) }
      end
      it "creates a new location" do
        Location.count.should == @count + 1
      end
      it "shows the newly created location" do
        response.should redirect_to Location.last
      end
      it "reverse geolocates the model" do
        Location.last.address.should == 'Las Vegas, NV'
      end
    end
  end

  describe "GET 'show'" do
    before do
      @loc = FactoryGirl.create :location
      @tip1 = FactoryGirl.create :tip, location: @loc
      @tip2 = FactoryGirl.create :tip, location: @loc
      get :show, :id => @loc.id
    end
    it "should assign location and tips" do
      assigns(:location).should == @loc
      assigns(:tips).should include(@tip1)
      assigns(:tips).should include(@tip2)
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
        get :near, :lat => "47.6187812537455", :lng => "-122.302367052115"
      end
      it 'returns json' do
        response.should be_success
        response.content_type.should == "application/json"
      end
      context "without lat / long on query string" do
        it "returns an error" do
          get :near
          response.should_not be_success
        end
      end
      context "when an error is raised due to too many results" do
        before do
          locations = []
          locations.stub(:count).and_return 1001
          Location.stub(:within_bounding_box).and_return locations
          get :near, :lat => "47.6187812537455", :lng => "-122.302367052115"
        end
        it "returns a 500 error" do
          response.should_not be_success
          response.response_code.should == 500
          response.body.should =~ /Too many/
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
    end
  end

end
