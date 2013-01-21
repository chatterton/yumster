require 'spec_helper'

describe LocationsHelper do
  describe "#gmaps4rails_opts" do
    before do
      @location = stub_model Location, :latitude => 40.01, :longitude => 42, :description => 'fooo'
    end

    it "can use a single location to build map options" do
      opts = gmaps4rails_opts(@location)
      opts.to_json.should match /40.01/
      opts.to_json.should match /42/
    end
  end
end
