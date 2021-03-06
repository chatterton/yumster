require 'spec_helper'

describe "locations/new" do
  before do
    @location = mock_model Location
    assign(:location, @location)
    assign(:g4r_options, {})
    view.stub(:user_signed_in?).and_return false
    render
  end

  it 'displays a form with the right fields' do
    rendered.should have_selector("form")
    rendered.should have_selector("form input#location_latitude[type='hidden']")
    rendered.should have_selector("form input#location_longitude[type='hidden']")
    rendered.should have_selector("form input#location_description[type='text']")
    rendered.should have_selector("form input#location_category_plant[type='radio']")
    rendered.should have_selector("form input#location_category_dumpster[type='radio']")
    rendered.should have_selector("form input#location_category_organization[type='radio']")
    rendered.should have_selector("form input[type='submit']")
  end

  it 'shows a map' do
    rendered.should have_selector '.map_container #map_canvas'
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
