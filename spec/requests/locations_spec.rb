require 'spec_helper'
require 'auth_helper'

describe "Locations pages" do
  include AuthHelper

  context "when a user is logged in" do
    before do
      log_in_a_user
    end
    describe "new page" do
      it 'should show a form' do
        visit new_location_path
        page.should have_selector("form")
      end
    end
    describe "invalid form contents" do
      it "should not increase the location count" do
        visit new_location_path
        expect { click_button "Create location" }.not_to change(Location, :count)
      end
    end
    describe "valid form contents" do
      it "should increase the location count" do
        visit new_location_path
        find(:xpath, "//input[@id='location_latitude']").set "16"
        find(:xpath, "//input[@id='location_longitude']").set "16"
        choose "location_category_dumpster"
        fill_in "location_description", with: "fooood"
        Geocoder.configure(:lookup => :test)
        Geocoder::Lookup::Test.add_stub([16.0, 16.0], [])
        expect { click_button "Create location" }.to change(Location, :count)
      end
    end
  end

  describe "show page" do
    let(:location) { FactoryGirl.create(:location, :description => "zippy's pizza") }

    before { visit location_path(location) }

    it 'should show the description' do
      page.should have_content("zippy's pizza")
    end
  end
end
