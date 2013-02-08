require 'spec_helper'

describe "Locations pages" do
  describe "new page" do
    it 'should show a form' do
      LocationsController.any_instance.stub(:current_user).and_return(FactoryGirl.create :user)
      visit new_location_path
      page.should have_selector("form")
    end
  end

  context "when a user is logged in" do
    before do
      @user = FactoryGirl.create :user
      LocationsController.any_instance.stub(:current_user).and_return(@user)
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
