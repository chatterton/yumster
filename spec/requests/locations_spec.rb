require 'spec_helper'
require 'auth_helper'

describe "Locations pages" do
  include AuthHelper

  context "when a user is logged in" do
    before do
      log_in_a_user
    end
    describe "invalid form contents" do
      it "should not increase the location count" do
        visit new_location_path
        expect { click_button "Create location" }.not_to change(Location, :count)
      end
    end
    describe "valid form contents" do
      before do
        visit new_location_path
        find(:xpath, "//input[@id='location_latitude']").set "16"
        find(:xpath, "//input[@id='location_longitude']").set "16"
        choose "location_category_dumpster"
        fill_in "location_description", with: "fooood"
        Geocoder.configure(:lookup => :test)
        Geocoder::Lookup::Test.add_stub([16.0, 16.0], [{'address' => '123 Streetname'}])
      end
      it "should increase the location count" do
        expect { click_button "Create location" }.to change(Location, :count)
      end
      it "reverse geolocates for the address" do
        click_button "Create location"
        page.should have_content "123 Streetname"
      end
    end
  end

  describe "new page" do
    it 'should show a form' do
      visit new_location_path
      page.should have_selector("form")
    end
  end

  describe "show page" do
    let(:location) { FactoryGirl.create(:location, :description => "zippy's pizza") }

    before { visit location_path(location) }

    it 'should show the description' do
      page.should have_content("zippy's pizza")
    end
  end

  describe "near page json" do
    before do
      FactoryGirl.create(:location)
      get near_locations_path, { :lat => 11.2, :lng => 11.4, :format => :json }
    end
    it "gets json back" do
      response.should be_success
      response.header['Content-Type'].should include 'application/json'
    end
    it "only includes the right data" do
      parsed = JSON.parse(response.body)
      parsed.length.should == 1
      location = parsed[0]

      location["id"].should be
      location["description"].should be
      location["latitude"].should be
      location["longitude"].should be
      location["category"].should be
      location["tips_count"].should be

      location["address"].should_not be
      location["city"].should_not be
      location["country"].should_not be
      location["neighborhood"].should_not be
      location["postal_code"].should_not be
      location["state"].should_not be
      location["state_code"].should_not be
      location["street"].should_not be
      location["user_id"].should_not be
      location["created_at"].should_not be
      location["updated_at"].should_not be
    end
  end

end
