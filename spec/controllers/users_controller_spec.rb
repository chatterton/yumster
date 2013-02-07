require 'spec_helper'

describe UsersController do

  describe "GET #show" do
    before do
      @user = FactoryGirl.create :user
      get :show, username:@user.username
    end
    it "assigns @user based on username" do
      assigns(:user).should == @user
    end
    it "should render the right template" do
      response.should render_template :show
    end
    context "when the user does not exist" do
      it "should return an error" do

      end
    end
  end

end
