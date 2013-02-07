require 'spec_helper'

describe "User pages" do
  
  describe "register user" do
    before do
      visit new_user_registration_path
    end
    it 'should show a form' do
      page.should have_selector("form")
    end
    describe "invalid form contents" do
      it "should not increase the user count" do
        expect { click_button "Sign up" }.not_to change(User, :count)
      end
    end
    describe "valid form contents" do
      it "should increase the user count" do
        fill_in "Email", with: "user@wherever.com"
        fill_in "Username", with: "username"
        fill_in "Password", with: "password"
        fill_in "Password confirmation", with: "password"
        expect { click_button "Sign up" }.to change(User, :count)
      end
    end

  end
end
