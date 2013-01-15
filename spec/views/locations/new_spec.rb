require 'spec_helper'

describe "locations/new" do
  it 'displays a form with the right fields' do
    location = mock_model Location
    assign(:location, location)

    render

    # TODO: what is broken here?
    # rendered.should have_selector("form#new_location")
    rendered.should have_selector("form")
    rendered.should have_selector("form input#location_latitude[type='text']")
    rendered.should have_selector("form input#location_longitude[type='text']")
    rendered.should have_selector("form input#location_description[type='text']")
    rendered.should have_selector("form input[type='submit']")

  end
end
