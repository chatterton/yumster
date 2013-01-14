require 'spec_helper'

describe "locations/show.html.erb" do
  let(:location) { FactoryGirl.create(:location) }

  before { visit location_path(location) }

  it 'should show the description' do
    page.should have_content("description: a location")
  end
end
