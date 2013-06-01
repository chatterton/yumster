require 'spec_helper'
require 'auth_helper'

describe "Locations pages" do
  include AuthHelper

  context "when a user is logged in" do
    before do
      @user = log_in_a_user
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
    describe "updating a location's notes" do
      before do
        @loc = FactoryGirl.create :location, :user_id => @user.id
      end
      context "as the user who created the notes" do
        before do
          visit location_path @loc
          fill_in 'location_notes', with: 'doom'
          click_button "save_notes"
        end
        it "saves the notes to the location" do
          @check = Location.find @loc.id
          @check.notes.should == "doom"
        end
      end
      context "as an admin user" do
        before do
          log_out_all_users
          @user = log_in_an_admin
          visit location_path @loc
          fill_in 'location_notes', with: 'yummm'
          click_button "save_notes"
        end
        it "saves the notes to the location" do
          @check = Location.find @loc.id
          @check.notes.should == "yummm"
        end
      end
    end
  end

  describe "new page" do
    before do
      visit new_location_path
    end
    it 'should show a form' do
      page.should have_selector("form")
    end
    it 'should show a moderation warning' do
      page.should have_selector "p.alert-info"
      page.should have_content "anonymously"
    end
    context 'when a user has signed in' do
      before do
        log_in_a_user
        visit new_location_path
      end
      it "should not show the moderation warning" do
        page.should_not have_selector "p.alert-info"
        page.should_not have_content "anonymously"
      end
    end
  end

  describe "show page" do
    let(:location) { FactoryGirl.create(:location, :description => "zippy's pizza") }

    before { visit location_path(location) }

    it 'should show the description' do
      page.should have_content("zippy's pizza")
    end

    it 'should use the description in the page title' do
      page.should have_xpath '//title', :text => "zippy's pizza"
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

  describe "near page html" do
    before do
      visit near_locations_path
    end
    it "sets the page title correctly for an html response" do
      page.should have_xpath '//title', :text => "Nearby Locations"
    end
  end

end
