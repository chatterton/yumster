module AuthHelper
  include Warden::Test::Helpers

  def build_a_user
    user = FactoryGirl.create :user
    user.confirm!
    user
  end

  def log_in_a_user
    user = build_a_user
    log_in(user)
    user
  end

  def log_in_an_admin
    user = build_a_user
    user.admin = true
    user.save
    log_in(user)
    user
  end

  def log_in(user)
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "Sign in"
    user
  end

  def log_out_all_users
    logout
  end

end
