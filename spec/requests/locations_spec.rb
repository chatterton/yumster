require 'spec_helper'

def log_in_a_user
  user = FactoryGirl.create :user
  user.confirm!
  visit new_user_session_path
  fill_in "user_email", with: user.email
  fill_in "user_password", with: user.password
  click_button "Sign in"
  user
end

describe "Locations pages" do

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
        select "Dumpster", :from => "Category"
        fill_in "Description", with: "fooood"
        expect { click_button "Create location" }.to change(Location, :count)
      end
    end
  end

  describe "show page" do
    let(:location) { FactoryGirl.create(:location) }

    before { visit location_path(location) }

    it 'should show the description' do
      page.should have_content("a location")
    end
  end
end
