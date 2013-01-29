require 'spec_helper'

describe "static pages" do
  describe "home page" do
    before do
      visit '/pages/home'
    end
    subject { page }
    it { should have_content 'Yumster' }
    it 'should link to nearby locations' do
      page.should have_link "Find nearby locations", :href => "/locations"
    end
    it 'should link to create a location' do
      page.should have_link "Add a location", :href => "/locations/new"
    end
  end
end
