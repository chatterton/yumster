module AuthHelper

  def log_in_a_user
    user = FactoryGirl.create :user
    user.confirm!
    log_in(user)
  end

  def log_in(user)
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "Sign in"
    user
  end

end
