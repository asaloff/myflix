require 'spec_helper'

feature "User interacts with queue" do
  scenario "user adds and reorders videos in the queue" do

    comedy = Fabricate(:category)
    sarah = Fabricate(:user)
    futurama = Fabricate(:video, title: 'Futurama', category: comedy)
    south_park = Fabricate(:video, title: 'South Park', category: comedy)
    monk = Fabricate(:video, title: 'Monk', category: comedy)

    sign_in

    add_video_to_queue(futurama)

    visit my_queue_path
    expect_video_to_be_in_queue(futurama)

    navigate_to_queued_video(futurama)
    expect_to_be_on_video_page(futurama)
    expect_hidden_link('+ My Queue')

    add_video_to_queue(south_park)
    add_video_to_queue(monk)

    visit my_queue_path

    set_video_postion(futurama, 3)
    set_video_postion(south_park, 1)
    set_video_postion(monk, 2)

    update_queue

    expect_updated_position(south_park, 1)
    expect_updated_position(monk, 2)
    expect_updated_position(futurama, 3)
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link '+ My Queue'
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def navigate_to_queued_video(video)
    click_link video.title
  end

  def expect_to_be_on_video_page(video)
    expect(page).to have_content(video.title)
  end

  def expect_hidden_link(link_text)
    expect(page).to have_no_content(link_text)
  end

  def set_video_postion(video, position)
    within("//tr[contains('#{video.title}')]") do
      fill_in("queue_items[][position]", with: position)
    end
  end

  def update_queue
    click_button 'Update Instant Queue'
  end

  def expect_updated_position(video, position)
    expect(find("//tr[contains('#{video.title}')]//input[name='queue_items[][position]']").value).to eq(position.to_s)
  end
end
