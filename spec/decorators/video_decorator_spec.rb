require 'spec_helper'

describe VideoDecorator do
  describe '#display_rating' do
    let(:video) { Fabricate(:video).decorate }

    it "returns the rating if the video has any reviews" do
      Fabricate(:review, video: video, rating: 5)
      expect(video.rating).to eq "Average Rating: 5.0 / 5"
    end

    it "returns 'N/A if the video has no reviews" do
      expect(video.rating).to eq "N/A"
    end
  end
end
