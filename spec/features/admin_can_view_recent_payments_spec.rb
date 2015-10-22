require 'spec_helper'

feature "view recent payments" do
  background do
    sarah = Fabricate(:user, full_name: "Sarah Doe", email: "sarah@example.com")
    Fabricate(:payment, user: sarah, amount: 999)
  end

  scenario "user is an admin" do
    sign_in(Fabricate(:user, admin: true))

    visit admin_payments_path
    expect(page).to have_content "Sarah Doe"
    expect(page).to have_content "sarah@example.com"
    expect(page).to have_content "$9.99"
  end

  scenario "user is not an admin" do
    sign_in(Fabricate(:user, admin: false))

    visit admin_payments_path
    expect(page).not_to have_content "Sarah Doe"
    expect(page).not_to have_content "sarah@example.com"
    expect(page).not_to have_content "$9.99"
  end
end