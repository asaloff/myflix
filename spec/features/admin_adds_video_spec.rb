require 'spec_helper'

feature "admin adds a video" do
  scenario "admin can successfully add a video" do
    Fabricate(:category, title: "Detective")
    admin = Fabricate(:user, admin: true)

    sign_in(admin)
    navigate_to_add_video_page
    submit_new_video

    sign_out
    sign_in #as non-admin

    expect_small_cover_image
    visit video_path(Video.first)
    expect_large_cover_image
    expect_video_url
  end

  def navigate_to_add_video_page
    visit new_admin_video_path
    expect(page).to have_content "Add a New Video"
  end

  def submit_new_video
    fill_in "Title", with: "Monk"
    select "Detective", from: "Category"
    fill_in "Description", with: "A detective with OCD"
    attach_file "Large cover", 'spec/support/uploads/monk_large.jpg'
    attach_file "Small cover", 'spec/support/uploads/monk.jpg'
    fill_in "Video URL", with: "www.examplevideo.com/video1.mp4"
    click_button "Add Video"
    expect(page).to have_content "The video Monk was created."
  end

  def expect_small_cover_image
    expect(page).to have_selector("img[src='/uploads/monk.jpg']")
  end

  def expect_large_cover_image
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
  end

  def expect_video_url
    expect(page).to have_selector("a[href='www.examplevideo.com/video1.mp4']") 
  end
end
