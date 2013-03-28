require 'spec_helper'

describe "users/show" do

  before do
    @user = FactoryGirl.create :user, :username => 'elmer'
    loc1 = FactoryGirl.create :location, user: @user
    loc2 = FactoryGirl.create :location, user: @user
    assign(:user, @user)
    view.stub(:user_signed_in?).and_return(true)
    view.stub(:current_user).and_return(@user)
    view.stub(:gravatar_for).and_return "avatar goes here"
  end

  it "should show the user's username" do
    render
    rendered.should =~ /elmer/
  end

  it "should show the user's location count" do
    render
    rendered.should =~ /2 locations/
  end

  context "when a user is signed in" do
    # this is the default from the before block
    it "should show a log out link" do
      render
      rendered.should have_link '', href: destroy_user_session_path
    end
    it "should show a link to gravatar" do
      render
      rendered.should have_link '', href: 'https://en.gravatar.com/site/login'
    end
  end
  context "when a user is somebody else" do
    before do
      user2 = FactoryGirl.create :user, :username => 'teddy', :email => 'x@ya.com'
      view.stub(:current_user).and_return(user2)
    end
    it "should not show a log out link" do
      render
      rendered.should_not have_link '', href: destroy_user_session_path
    end
  end

  it "should show the user's gravatar" do
    render
    rendered.should have_content "avatar goes here"
  end

end
