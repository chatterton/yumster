require 'spec_helper'

describe "locations/near" do

  before do
    assign(:g4r_options, {})
    render
  end

  subject { rendered }

  describe 'it shows a map' do
    it { should have_selector '.map_container #map' }
  end

  describe 'has a hidden link to the nearby ajax endpoint' do
    it { should have_link "", href: near_locations_path }
  end

end
