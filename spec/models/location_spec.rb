require 'spec_helper'

describe Location do
  before do
    @location = Location.new(description: 'test desc', latitude: 100, longitude: 101)
  end

  it "should have the proper attributes" do
    @location.should respond_to(:description)
    @location.description.should == 'test desc'
    @location.should respond_to(:latitude)
    @location.latitude.should == 100
    @location.should respond_to(:longitude)
    @location.longitude.should == 101
  end

  describe "when description is not present" do
    before { @location.description = " " }
    it "should not be valid" do
      @location.should_not be_valid
    end
  end

  describe "when latitude and longitude are not present" do
    before do
      @location.latitude = nil
      @location.longitude = nil
    end
    it "should not be valid" do
      @location.should_not be_valid
    end
  end

  describe "when latitude and longitude are present" do
    before do
      @location.latitude = 5
      @location.longitude = -5
    end
    
    it "should be valid with a valid lat/long pair" do
      @location.should be_valid
    end

    it "should not be valid with an invalid latitude" do
      @location.latitude = -91
      @location.should_not be_valid
    end

    it "should not be valid with an invalid longitude" do
      @location.latitude = -181
      @location.should_not be_valid
    end
  end

end
