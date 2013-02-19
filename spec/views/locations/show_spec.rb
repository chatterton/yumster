require 'spec_helper'

describe "locations/show" do

  before do
    location = stub_model Location, :latitude => 40, :longitude => 42, :description => 'fooo', :category => "Plant"
    assign(:location, location)
    assign(:g4r_options, {})
  end

  it 'displays category and description' do
    render
    rendered.should =~ /fooo/
    rendered.should =~ /Plant/
  end

  it 'shows a map' do
    render
    rendered.should have_selector '.map_container #map_canvas'
  end

end
