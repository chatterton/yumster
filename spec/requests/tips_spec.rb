require 'spec_helper'
require 'auth_helper'

describe "Tips pages" do
  include AuthHelper

  let(:location) { FactoryGirl.create :location }

  before do
    log_in_a_user
  end

  context "when no user is logged in" do
    it 'should not show the form' do
      visit location_path(location)
      page.should have_selector "form[action='#{tips_path}']"
    end
  end
  context "when no user is logged in" do
    it 'should not show the form' do
      log_out_all_users
      visit location_path(location)
      page.should_not have_selector "form[action='#{tips_path}']"
    end
  end

end
