require 'spec_helper'

feature 'user can login' do
  scenario 'with valid inputs' do
    user = Fabricate(:user)
    sign_in(user)
    expect(page).to have_content user.full_name
  end
end