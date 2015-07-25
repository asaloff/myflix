require 'spec_helper'

describe QueueItem do
  it { should validate_presence_of :user }
  it { should validate_presence_of :video }

  describe '#video_title' do
    it "returns the video's title for the queue item" do
      sarah = Fabricate(:user)
      video = Fabricate(:video, title: 'Futurama')
      queue_item = Fabricate(:queue_item, user: sarah, video: video)
      expect(queue_item.video_title).to eq('Futurama')
    end
  end

  describe '#rating' do
    it "returns the rating for the queue item's when the review exists" do
      sarah = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: sarah, video: video, rating: 5)
      queue_item = Fabricate(:queue_item, user: sarah, video: video)
      expect(queue_item.rating).to eq(5)
    end

    it "returns nil when there is no review" do
      sarah = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: sarah, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe '#category_name' do
    it "returns the video's category name" do
      category = Fabricate(:category, title: "Comedy")
      sarah = Fabricate(:user)
      video = Fabricate(:video, category: Category.first)
      queue_item = Fabricate(:queue_item, user: sarah, video: video)
      expect(queue_item.category_name).to eq("Comedy")
    end
  end

  describe '#category' do
    it "returns the video's category" do
      category = Fabricate(:category, title: "Comedy")
      sarah = Fabricate(:user)
      video = Fabricate(:video, category: Category.first)
      queue_item = Fabricate(:queue_item, user: sarah, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
end




