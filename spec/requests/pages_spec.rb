require 'spec_helper'

describe "static pages" do
  describe "home page" do
    it 'should say Yumster somewhere on it' do
      visit '/pages/home'
      page.should have_content 'Yumster'
    end
  end
end
