require 'spec_helper'

describe "locations/show" do

  before do
    location = stub_model Location, :latitude => 40, :longitude => 42, :description => 'fooo'
    assign(:location, location)
    assign(:g4r_options, {})
  end

  it 'displays lat, long, and description' do
    render
    rendered.should =~ /40/
    rendered.should =~ /42/
    rendered.should =~ /fooo/
  end

  it 'shows a map' do
    render
    rendered.should have_selector '.map_container #map'
  end

end
