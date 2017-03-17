require 'spec_helper'

describe "User pages" do

  describe "register" do
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

  describe "sign in" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      user.confirm
      visit new_user_session_path
    end
    describe "signing in with an email" do
      it "should work" do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
        page.should have_content("Signed in successfully.")
      end
    end
    describe "signing in with a username" do
      it "should work" do
        fill_in "Email", with: user.username
        fill_in "Password", with: user.password
        click_button "Sign in"
        page.should have_content("Signed in successfully.")
      end
    end
    describe "signing in with garbage" do
      it "should not work" do
        fill_in "Email", with: "garbage"
        fill_in "Password", with: user.password
        click_button "Sign in"
        page.should_not have_content("Signed in successfully.")
        page.should have_content("Invalid")
      end
    end
  end

end
