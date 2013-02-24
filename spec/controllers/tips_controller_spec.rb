require 'spec_helper'

describe TipsController do

  describe "POST 'create'" do
    before do
      sign_in_user
    end
    it "redirects to locations#show" do
      loc = FactoryGirl.create :location, :user_id => 999
      post 'create', :tip => { :location_id => loc.id }
      response.should redirect_to loc
    end
  end

end
