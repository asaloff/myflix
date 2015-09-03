require 'spec_helper'

feature 'user can follow others' do
  scenario 'user follows and unfollows another user' do
    comedy = Fabricate(:category)
    sarah = Fabricate(:user)
    bob = Fabricate(:user)
    futurama = Fabricate(:video, title: 'Futurama', category: comedy)
    review = Fabricate(:review, user: bob, video: futurama)

    sign_in(sarah)
    visit home_path

    find("a[href='/videos/#{futurama.id}']").click
    click_link bob.full_name
    click_button 'Follow'
    expect(page).to have_no_content('Follow')

    visit people_path
    expect(page).to have_content(bob.full_name)

    unfollow(sarah, bob)
    expect(page).to have_no_content(bob.full_name)
  end

  def unfollow(follower_name, following_name)
    relationship = Relationship.find_by(user: follower_name, following: following_name)
    find("a[href='/relationships/#{relationship.id}']").click
  end
end