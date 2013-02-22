require 'spec_helper'

describe "locations/near" do

  before do
    render
  end

  subject { rendered }

  describe 'it shows a map' do
    it { should have_selector '.map_container #map_canvas' }
  end

  describe 'has a hidden link to the nearby ajax endpoint' do
    it { should have_link "", href: near_locations_path }
  end

  describe 'has an address search field' do
    it { should have_css 'input#map_address_input' }
  end

end
