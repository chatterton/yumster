require 'spec_helper'

RSpec.configure do |config|
  config.include Devise::TestHelpers
end

describe 'layouts/application' do
  context 'when no user is signed in' do
    before do
      view.stub(:user_signed_in?).and_return(false)
      render
    end
    it 'displays a log in link' do
      rendered.should have_link "Log In", :href => new_user_session_path
    end
  end
  context 'when a user is signed in' do
    before do
      view.stub(:user_signed_in?).and_return(true)
      render
    end
    it 'displays a log out link' do
      rendered.should_not have_link "Log In", :href => new_user_session_path
      rendered.should have_link "Log Out", :href => destroy_user_session_path
    end
  end
end
