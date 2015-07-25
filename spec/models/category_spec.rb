require 'spec_helper'

describe Category do
  it { should have_many :videos }
  it { should validate_uniqueness_of :title }
  it { should validate_presence_of :title }

  describe "#recent_videos" do
    it "returns an empty array if the there are no videos in the category" do
      comedy = Category.create(title: "Comedy")
      expect(comedy.recent_videos).to eq([])
    end

    it "returns the videos in the category" do
      comedy = Category.create(title: "Comedy")
      airplane = Video.create(title: "Airplane", description: "Airplane Humor", category: Category.first)
      futurama = Video.create(title: "Futurama", description: "Space Humor", category: Category.first)
      expect(comedy.recent_videos.count).to eq(2)
    end

    it "returns the most recent videos" do
      comedy = Category.create(title: "Comedy")
      airplane = Video.create(title: "Airplane", description: "Airplane Humor", category: Category.first, created_at: 2.day.ago)
      futurama = Video.create(title: "Futurama", description: "Space Humor", category: Category.first, created_at: 3.day.ago)
      anchorman = Video.create(title: "Anchorman", description: "Anchor Humor", category: Category.first, created_at: 1.day.ago)
      expect(comedy.recent_videos).to eq([anchorman, airplane, futurama])
    end

    it "returns only 6 videos if there are more than 6 in the category" do
      comedy = Category.create(title: "Comedy")
      vid1 = Video.create(title: "Airplane", description: "Airplane Humor", category: Category.first, created_at: 1.day.ago)
      vid2 = Video.create(title: "Futurama", description: "Space Humor", category: Category.first, created_at: 2.day.ago)
      vid3 = Video.create(title: "Anchorman", description: "Anchor Humor", category: Category.first, created_at: 3.day.ago)
      vid4 = Video.create(title: "Ted", description: "Bear Humor", category: Category.first, created_at: 4.day.ago)
      vid5 = Video.create(title: "Superbad", description: "Teen Humor", category: Category.first, created_at: 5.day.ago)
      vid6 = Video.create(title: "Ghost Busters", description: "Ghost Humor", category: Category.first, created_at: 6.day.ago)
      vid7 = Video.create(title: "Zoolander", description: "Fashion Humor", category: Category.first, created_at: 7.day.ago)
      expect(comedy.recent_videos.count).to eq(6)
    end
  end
end