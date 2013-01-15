require 'spec_helper'

describe "locations/index" do
  it 'displays all entries in @locations' do
    location1 = double('Location', :description => "desc1").as_null_object
    location2 = double('Location', :description => "desc2").as_null_object
    assign(:locations, [location1, location2])

    render

    rendered.should have_content "desc1"
    rendered.should have_content "desc2"
  end
end
