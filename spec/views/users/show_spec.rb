require 'spec_helper'

describe "users/show" do

  before do
    @user = FactoryGirl.create :user, :username => 'elmer'
    loc1 = FactoryGirl.create :location, user: @user
    loc2 = FactoryGirl.create :location, user: @user
    assign(:user, @user)
  end

  it "should show the user's username" do
    render
    rendered.should =~ /elmer/
  end

  it "should show the user's location count" do
    render
    rendered.should =~ /2 locations/
  end

end
