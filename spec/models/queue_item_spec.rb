require 'spec_helper'

describe QueueItem do
  it { should validate_presence_of :user }
  it { should validate_presence_of :video }
  it { should validate_numericality_of(:position).only_integer }
  it { should delegate_method(:category).to(:video) }
  it { should delegate_method(:title).to(:video).with_prefix(:video) }

  describe '#rating' do
    let(:sarah) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:queue_item) { Fabricate(:queue_item, user: sarah, video: video) }

    it "returns the rating for the queue item's when the review exists" do
      review = Fabricate(:review, user: sarah, video: video, rating: 5)
      expect(queue_item.rating).to eq(5)
    end

    it "returns nil when there is no review" do
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe '#rating=' do
    let(:sarah) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:queue_item) { Fabricate(:queue_item, user: sarah, video: video) }

    it "updates the rating if a review is present" do
      review = Fabricate(:review, user: sarah, video: video, rating: 3)
      queue_item.rating = 4
      expect(review.reload.rating).to eq(4) 
    end

    it "creates a rating if the review is not present" do
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4) 
    end

    it "removes the rating when the input is blank" do
      review = Fabricate(:review, user: sarah, video: video, rating: 4)
      queue_item.rating = nil
      expect(review.reload.rating).to be_nil
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
end




