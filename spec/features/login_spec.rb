require 'spec_helper'

feature 'user login' do
  scenario 'with valid inputs' do
    user = Fabricate(:user)
    sign_in(user)
    expect(page).to have_content user.full_name
  end

  scenario 'with an inactive user' do
    user = Fabricate(:user, active: false)
    sign_in(user)
    expect(page).not_to have_content user.full_name
    expect(page).to have_content "Your account was deactivated. Please contact customer service."
  end
end