require 'spec_helper'

describe 'layouts/application' do
  context 'when no user is signed in' do
    before do
      view.stub(:user_signed_in?).and_return(false)
      render
    end
    it 'displays a log in link' do
      rendered.should have_link "Sign in", :href => new_user_session_path
    end
  end
  context 'when a user is signed in' do
    before do
      view.stub(:user_signed_in?).and_return(true)
      @user = FactoryGirl.create :user, :username => "fred"
      view.stub(:current_user).and_return(@user)
      render
    end
    it 'displays username linked to the account page' do
      rendered.should_not have_link "Log In", :href => new_user_session_path
      rendered.should have_link @user.username, :href => user_path(@user.username)
    end
  end
end
