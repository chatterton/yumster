require 'spec_helper'

describe "locations/index" do
  before do
    user = FactoryGirl.create :user
    location1 = FactoryGirl.create :location, user: user
    location2 = FactoryGirl.create :location, user: user
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
