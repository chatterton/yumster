require 'spec_helper'

describe 'layouts/application' do
  before do
    view.stub(:user_signed_in?).and_return(false)
  end

  context 'when no user is signed in' do
    it 'displays a log in link' do
      render
      rendered.should have_link "Sign In", :href => new_user_session_path
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
      rendered.should_not have_link "", :href => new_user_session_path
      rendered.should have_link "", :href => user_path(@user.username)
    end
  end

  it 'displays a link to the about page' do
    render
    rendered.should have_link "About", :href => pages_about_path
  end
end
