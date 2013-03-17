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
      it "returns http success" do
        user = sign_in_user
        user.admin = true
        user.save
        get 'locations'
        response.should be_success
      end
    end
  end

end
