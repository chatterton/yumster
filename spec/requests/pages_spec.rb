require 'spec_helper'

describe "static pages" do
  describe "home page" do
    before do
      visit '/pages/home'
    end
    subject { page }
    it { should have_content 'Yumster' }
    it 'should link to nearby locations' do
      page.should have_link "", :href => "/locations/near"
    end
    it 'should link to create a location' do
      page.should have_link "", :href => "/locations/new"
    end
    it 'should show the big tagline brand image' do
      page.should have_selector 'img.brand_tagline'
    end
  end
end
