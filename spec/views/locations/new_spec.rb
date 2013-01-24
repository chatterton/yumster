require 'spec_helper'

describe "locations/new" do
  before do
    @location = mock_model Location
    assign(:location, @location)
    assign(:g4r_options, {})
  end

  it 'displays a form with the right fields' do
    render
    rendered.should have_selector("form")
    rendered.should have_selector("form input#location_latitude[type='hidden']")
    rendered.should have_selector("form input#location_longitude[type='hidden']")
    rendered.should have_selector("form input#location_description[type='text']")
    rendered.should have_selector("form input[type='submit']")
  end

  it 'shows a map' do
    render
    rendered.should have_selector '.map_container #map'
  end

  describe "when there are errors" do
    before do
      errors = double(:full_messages => ["error1","error2"], :any? => true).as_null_object
      @location.stub!(:errors).and_return errors
    end
    it "displays them to the user" do
      render

      rendered.should have_content "error1"
      rendered.should have_content "error2"
    end
  end

end
