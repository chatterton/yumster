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
    it 'should link to the forums' do
      page.should have_link "", :href => forem.root_path
    end
  end

  describe "about page" do
    before do
      visit '/pages/about'
    end
    subject { page }
    it { should have_content 'About Us' }
    it 'should link to twitter' do
      page.should have_link "", :href => "http://twitter.com/yumster_mm"
    end
    it 'should show an email' do
      page.should have_content "yumster@yumster.co"
    end
    it 'should link to github' do
      page.should have_link "", :href => "http://github.com/chatterton/yumster"
    end
  end
end
