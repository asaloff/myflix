require 'spec_helper'

feature "user registration", :vcr, js: true do
  background do
    visit register_path
  end

  scenario "with valid user info and valid card" do
    fill_in_user_info('Bob Saget')
    fill_in_card('4242424242424242')
    click_button "Sign Up"
    expect(page).to have_content "You have registered successfully"
  end

  scenario "with valid user info and invalid card" do
    fill_in_user_info('Bob Saget')
    fill_in_card('1234')
    click_button "Sign Up"
    expect(page).to have_content "This card number looks invalid."
  end

  scenario "with valid user info and declined card" do
    fill_in_user_info('Bob Saget')
    fill_in_card('4000000000000002')
    click_button "Sign Up"
    expect(page).to have_content "Your card was declined."
  end

  scenario "with invalid user info and valid card" do
    fill_in_user_info('')
    fill_in_card('4242424242424242')
    click_button "Sign Up"
    expect(page).to have_content "can't be blank"
  end

  scenario "with invalid user info and invalid card" do
    fill_in_user_info('')
    fill_in_card('123')
    click_button "Sign Up"
    expect(page).to have_content "This card number looks invalid."
  end

  scenario "with invalid user info and declined card" do
    fill_in_user_info('')
    fill_in_card('4000000000000002')
    click_button "Sign Up"
    expect(page).to have_content "can't be blank"
  end

  def fill_in_user_info(name)
    fill_in "Email Address", with: "saggyb@example.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: name
  end

  def fill_in_card(card_number)
    fill_in "Credit Card Number", with: card_number
    fill_in "Security Code", with: "123"
    find('#date_month').find(:xpath, 'option[12]').select_option
    find('#date_year').find(:xpath, 'option[5]').select_option
  end
end
