require 'spec_helper'

describe "Locations pages" do
  describe "new page" do
    before do
      visit new_location_path
    end
    it 'should show a form' do
      page.should have_selector("form")
    end
    describe "invalid form contents" do
      it "should not increase the loction count" do
        visit new_location_path
        expect { click_button "Create location" }.not_to change(Location, :count)
      end
    end
  end

  describe "show page" do
    let(:location) { FactoryGirl.create(:location) }

    before { visit location_path(location) }

    it 'should show the description' do
      page.should have_content("description: a location")
    end
  end
end
