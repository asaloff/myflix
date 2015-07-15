require 'spec_helper'

describe Video do
  it { should belong_to :category }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_uniqueness_of :title }

  describe "search_by_title" do
    it "returns an empty array if there is no matches" do
      futurama = Video.create(title: "Futurama", description: "Space cartoon")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title("hello")).to eq([])
    end

    it "returns an array with one video for an exact match" do
      futurama = Video.create(title: "Futurama", description: "Space cartoon")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title("Futurama")).to eq([futurama])
    end

    it "returns an array with one video for a partial match" do
      futurama = Video.create(title: "Futurama", description: "Space cartoon")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title('rama')).to eq([futurama])
    end

    it "returns an array of all matches ordered by created_at" do
      futurama = Video.create(title: "Futurama", description: "Space cartoon", created_at: 1.day.ago)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel", created_at: 2.day.ago)
      expect(Video.search_by_title('Futur')).to eq([back_to_future, futurama])
    end

    it "returns an empty array for a blank search" do
      futurama = Video.create(title: "Futurama", description: "Space cartoon")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title('')).to eq([])
    end

    it "searches for title in lowercase" do
      futurama = Video.create(title: "Futurama", description: "Space cartoon")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title("futurama")).to eq([futurama])
    end
  end
end


