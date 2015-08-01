require 'spec_helper'

describe Video do
  it { should belong_to :category }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_uniqueness_of :title }

  describe "search_by_title" do
    let(:futurama) { Fabricate(:video, title: "Futurama", description: "Space cartoon", created_at: 1.day.ago) }
    let(:back_to_future) { Fabricate(:video, title: "Back to Future", description: "Time Travel", created_at: 2.day.ago) }

    it "returns an empty array if there is no matches" do
      expect(Video.search_by_title("hello")).to eq([])
    end

    it "returns an array with one video for an exact match" do
      expect(Video.search_by_title("Futurama")).to eq([futurama])
    end

    it "returns an array with one video for a partial match" do
      expect(Video.search_by_title('rama')).to eq([futurama])
    end

    it "returns an array of all matches ordered by created_at" do
      expect(Video.search_by_title('Futur')).to eq([back_to_future, futurama])
    end

    it "returns an empty array for a blank search" do
      expect(Video.search_by_title('')).to eq([])
    end

    it "searches for title in lowercase" do
      expect(Video.search_by_title("futurama")).to eq([futurama])
    end
  end
end


