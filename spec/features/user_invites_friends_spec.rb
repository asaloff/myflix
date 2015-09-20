require 'spec_helper'

feature "User invites a friend" do
  scenario "the friend can sign up" do
    sarah = Fabricate(:user)
    StripeMock.start_client

    sign_in(sarah)
    expect_to_be_signed_in(sarah)

    navigate_to_invite_page
    send_invitation

    expect_email_to_have_message

    current_email.click_link 'click here'
    expect_register_page_with_populated_email

    sign_up

    sign_in_new_user
    expect_new_user_to_follow_inviter(sarah)

    sign_in_as_inviter(sarah)
    expect_inviter_to_follow_new_user

    StripeMock.stop_client
  end

  def navigate_to_invite_page
    click_link "Invite a Friend"
    expect(page).to have_content "Invite a friend to join MyFlix!"
  end

  def send_invitation
    fill_in "Friend's Name", with: "Bob Saget"
    fill_in "Friend's Email Address", with: "saggy@example.com"
    fill_in "Invitation Message", with: "Please join this awesome site called MyFlix!"
    click_button "Send Invitation"
    expect(page).to have_content "Your invitation has been sent"
  end

  def expect_email_to_have_message
    open_email "saggy@example.com"
    expect(current_email).to have_content "Please join this awesome site called MyFlix!"
  end

  def expect_register_page_with_populated_email
    expect(page).to have_content "Register"
    expect(page).to have_selector("input[@value='saggy@example.com']")
  end

  def sign_up
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Bob Saget"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    find('#date_month').find(:xpath, 'option[12]').select_option
    find('#date_year').find(:xpath, 'option[5]').select_option
    click_button "Sign Up"
    expect(page).to have_content "You have registered successfully"
  end

  def sign_in_new_user
    fill_in "Email Address", with: "saggy@example.com"
    fill_in "Password", with: "password"
    click_button "Sign In"
  end

  def expect_new_user_to_follow_inviter(inviter)
    click_link "People"
    expect(page).to have_content inviter.full_name
  end

  def sign_in_as_inviter(inviter)
    click_link "Sign Out"
    click_link "Sign In"
    fill_in "Email Address", with: inviter.email
    fill_in "Password", with: inviter.password
    click_button "Sign In"
  end

  def expect_inviter_to_follow_new_user
    click_link "People"
    expect(page).to have_content "Bob Saget"
  end
end
