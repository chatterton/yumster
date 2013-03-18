require 'spec_helper'

describe User do
  before do
    @user = User.new(
      email: "test@user.com",
      password: "whatever",
      password_confirmation: "whatever",
      remember_me: true,
      username: "user999"
    )
  end

  subject { @user }

  it { should be_valid }
  it { should respond_to(:tip_locations) }

  describe "username" do
    it "should be three or more characters" do
      @user.username = "tw"
      @user.should_not be_valid
      @user.username = "thr"
      @user.should be_valid
    end
    it "should be no more than fifteen characters" do
      @user.username = "16____characters"
      @user.should_not be_valid
      @user.username = "15___characters"
      @user.should be_valid
    end
    it "should not accept spaces" do
      @user.username = "johnny rotten"
      @user.should_not be_valid
      @user.username = "johnny_rotten"
      @user.should be_valid
    end
  end

  describe "admin flag" do
    it "should default to false" do
      @user.admin.should == false
    end
    it "should be protected" do
      @user.class.accessible_attributes.should_not include :admin
    end
  end

end
