require 'spec_helper'

describe "locations/index" do
  before do
    location1 = FactoryGirl.create(:location) 
    location2 = FactoryGirl.create(:location) 
    @locations = [location1, location2]
    assign(:locations, @locations)
  end

  it 'links to entries in @locations' do
    render
    @locations.each do |loc|
      rendered.should have_link(loc.description, href: location_path(loc.id))
    end
  end
end
