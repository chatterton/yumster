require 'spec_helper'

describe TipsController do

  describe "POST 'create'" do
    before do
      @user = sign_in_user
      @location = FactoryGirl.create :location
      @loc_tips_count = @location.tips.count
      @user_tips_count = @user.tips.count
      post 'create', :tip => { :location_id => @location.id , :text => "sup yo" }
    end
    it "redirects to locations#show" do
      response.should redirect_to @location
    end
    it "adds a tip to the location" do
      @location.tips.count.should == @loc_tips_count + 1
    end
    it "adds a tip to the user" do
      @user.tips.count.should == @user_tips_count + 1
    end
  end

  describe "DELETE 'destroy'" do
    before do
      @location = FactoryGirl.create :location
      @user = sign_in_user
      @tip = FactoryGirl.create :tip, :user => @user, :location => @location
    end
    it "redirects to locations#show" do
      delete :destroy, id: @tip.id
      response.should redirect_to @location
    end
    it "deletes the tip" do
      expect{
        delete :destroy, id: @tip.id 
      }.to change(Tip, :count).by(-1)
    end
    context "when it is another user's tip" do
      before do
        @anotheruser = FactoryGirl.create :user
        @anothertip = FactoryGirl.create :tip, :user => @anotheruser, :location => @location
      end
      it "deletes the tip" do
        expect {
          delete :destroy, id: @anothertip.id
        }.not_to change(Tip, :count)
      end
      it "raises an error" do
        delete :destroy, id: @anothertip.id
        response.response_code.should == 403
      end
    end
  end

end
