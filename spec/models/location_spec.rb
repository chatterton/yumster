require 'spec_helper'

describe Location do
  before do
    @location = Location.new(description: 'test desc', latitude: 10, longitude: 101, category: "Plant")
  end

  subject { @location }

  describe "attributes" do
    it { should respond_to(:description) }
    it { should respond_to(:latitude) }
    it { should respond_to(:longitude) }
    it { should respond_to(:category) }
  end

  it "should have the proper values" do
    @location.description.should == 'test desc'
    @location.latitude.should == 10
    @location.longitude.should == 101
    @location.category.should == 'Plant'
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

end
