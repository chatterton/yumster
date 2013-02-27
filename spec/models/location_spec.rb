require 'spec_helper'

describe Location do
  before do
    @user = FactoryGirl.create(:user)
    @location = @user.locations.build(description: 'test desc', latitude: 10, longitude: 101, category: "Plant")
  end

  subject { @location }

  describe "attributes" do
    it { should respond_to(:description) }
    it { should respond_to(:latitude) }
    it { should respond_to(:longitude) }
    it { should respond_to(:category) }
    its(:user) { should == @user }
  end

  it "should have the proper values" do
    @location.description.should == 'test desc'
    @location.latitude.should == 10
    @location.longitude.should == 101
    @location.category.should == 'Plant'
    @location.user_id.should == @user.id
  end

  describe "when description is not present" do
    before { @location.description = " " }
    it { should_not be_valid }
  end

  describe "when latitude and longitude are not present" do
    before do
      @location.latitude = nil
      @location.longitude = nil
    end
    it { should_not be_valid }
  end

  describe "latitude and longitude value" do

    describe "with a valid lat/long pair" do
      before do
        @location.latitude = 5
        @location.longitude = -5
      end
      it { should be_valid }
    end
    describe "with an invalid latitude" do
      before do
        @location.latitude = -91
        @location.longitude = -5
      end
      it { should_not be_valid }
    end
    describe "with an invalid longitude" do
      before do
        @location.latitude = 5
        @location.longitude = -181
      end
      it { should_not be_valid }
    end
  end

  describe "when category is not present" do
    before do
      @location.category = nil
    end
    it { should_not be_valid }
  end

  describe "category value" do
    describe "with a valid category" do
      before do
        @location.category = 'Dumpster'
      end
      it { should be_valid }
    end
    describe "with an invalid category" do
      before do
        @location.category = 'Hotdog Stand'
      end
      it { should_not be_valid }
    end
  end

  describe "geocoding gem" do
    it { should respond_to(:distance_to) }
  end

  describe "access to user_id" do
    it "should not allow access" do
      expect do
        Location.new(user_id: 1111)
      end.to raise_error
    end
  end
  describe "when user_id is not present" do
    before do
      @location.user_id = nil
    end
    it { should_not be_valid }
  end

  describe "description length" do
    it "should be more than four characters" do
      @location.description = "four"
      @location.should_not be_valid
      @location.description = "fiive"
      @location.should be_valid
    end
    it "should be less than 46 characters" do
      @location.description = "this is a string of 46 characters............."
      @location.should_not be_valid
      @location.description = "this is a string of 45 characters............"
      @location.should be_valid
    end
  end

  describe "reverse geolocation" do
    it { should respond_to(:address) }
    it { should respond_to(:street) }
    it { should respond_to(:neighborhood) }
    it { should respond_to(:city) }
    it { should respond_to(:state) }
    it { should respond_to(:state_code) }
    it { should respond_to(:postal_code) }
    it { should respond_to(:country) }
    it { should respond_to(:country_code) }
    context "upon reverse geolocating"do
      before do
        firstresult = {
          'address' => 'aaa_address',
          'city' => 'aaa_city',
          'state' => 'aaa_state',
          'state_code' => 'aaa_state_code',
          'postal_code' => 'aaa_postal_code',
          'country' => 'aaa_country',
          'country_code' => 'aaa_country_code'
        }
        Geocoder.configure(:lookup => :test)
        Geocoder::Lookup::Test.add_stub(
          [10.0, 101.0],
          [firstresult, {'check' => 'nope'}]
        )
        @location.reverse_geocode()
      end
      it "sets the fields" do
        ## FIXME: Figure out how to test address_components_of_type
        @location.address.should == 'aaa_address' 
        @location.city.should == 'aaa_city'
        @location.state.should == 'aaa_state'
        @location.state_code.should == 'aaa_state_code'
        @location.postal_code.should == 'aaa_postal_code'
        @location.country.should == 'aaa_country'
        @location.country_code.should == 'aaa_country_code'
      end
    end
  end

end
