require 'spec_helper'

describe Category do
  it { should have_many :videos }
  it { should validate_uniqueness_of :title }
  it { should validate_presence_of :title }

  describe "#recent_videos" do
    let!(:comedy) { Category.create(title: "Comedy") }

    it "returns an empty array if the there are no videos in the category" do
      expect(comedy.recent_videos).to eq([])
    end

    it "returns the videos in the category" do
      2.times { Fabricate(:video, category: comedy) }
      expect(comedy.recent_videos.count).to eq(2)
    end

    it "returns the most recent videos" do
      airplane = Video.create(title: "Airplane", description: "Airplane Humor", category: Category.first, created_at: 2.day.ago)
      futurama = Video.create(title: "Futurama", description: "Space Humor", category: Category.first, created_at: 3.day.ago)
      anchorman = Video.create(title: "Anchorman", description: "Anchor Humor", category: Category.first, created_at: 1.day.ago)
      expect(comedy.recent_videos).to eq([anchorman, airplane, futurama])
    end

    it "returns only 6 videos if there are more than 6 in the category" do
      7.times { Fabricate(:video, category: comedy) }
      expect(comedy.recent_videos.count).to eq(6)
    end
  end
end