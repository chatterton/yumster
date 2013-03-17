require 'spec_helper'

describe AdminController do

  describe "GET 'locations'" do
    context "when nobody is logged in" do
      it "returns a 404" do
        get 'locations'
        response.response_code.should == 404
      end
    end
    context "when a user without the admin flag is logged in" do
      it "returns a 404" do
        sign_in_user
        get 'locations'
        response.response_code.should == 404
      end
    end
    context "when an admin is logged in" do
      before do
        user = sign_in_user
        user.admin = true
        user.save
        Location.stub(:find_unapproved) { ["foo"] }
      end
      it "returns http success" do
        get 'locations'
        response.should be_success
      end
      it "assigns @locations with all unapproved locations" do
        get 'locations'
        assigns(:locations).should == ["foo"]
      end
    end
  end

end
