require 'spec_helper'

feature 'user resets password' do
  scenario 'user requests and changes password through email link' do
    sarah = Fabricate(:user, password: "old_password")
    
    clear_emails
    request_password_reset_email(sarah)
    open_email sarah.email
    expect_email_to_have_users_name(sarah)

    current_email.click_link 'click here'
    expect_to_be_on_reset_password_page

    set_new_password
    expect_to_be_on_login_page

    sign_in_with_new_password(sarah)
    expect_to_be_signed_in(sarah)
  end

  def request_password_reset_email(user)
    visit login_path
    click_link "Forgot Password?" 
    expect_to_be_on_forgot_password_page
    fill_in "Email Address", with: user.email
    click_button 'Send Email'
  end

  def set_new_password
    fill_in "New Password", with: "new_password"
    click_button 'Reset Password'
  end

  def sign_in_with_new_password(user)
    fill_in "Email Address", with: user.email
    fill_in "Password", with: "new_password"
    click_button "Sign In"
  end

  def expect_to_be_on_forgot_password_page
    expect(page).to have_content "We will send you an email"
  end

  def expect_email_to_have_users_name(user)
    expect(current_email).to have_content user.full_name
  end

  def expect_to_be_on_reset_password_page
    expect(page).to have_content "Reset Your Password"
  end

  def expect_to_be_on_login_page
    expect(page).to have_content "Sign In"
  end

  def expect_to_be_signed_in(user)
    expect(page).to have_content "Welcome, #{user.full_name}"
  end
end
