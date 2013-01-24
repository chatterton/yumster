require 'spec_helper'

describe LocationsHelper do
  describe "#gmaps4rails_location" do
    before do
      @location = stub_model Location, :latitude => 40.01, :longitude => 42, :description => 'fooo'
    end

    it "can use a single location to build map options" do
      opts = gmaps4rails_location(@location)
      opts.to_json.should match /40.01/
      opts.to_json.should match /42/
    end
  end

  describe "#gmaps4rails_detect" do
    it "sets detect current location on options" do
      opts = gmaps4rails_detect
      opts[:map_options][:detect_location].should be_true
    end
  end
end
