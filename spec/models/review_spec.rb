require 'spec_helper'

describe Review do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of :rating }
  it { should validate_presence_of :video }
  it { should validate_presence_of :content }

  describe '#video_title' do
    it "returns the reviewed video's title" do
      sarah = Fabricate(:user)
      video = Fabricate(:video, title: "Monk")
      review = Fabricate(:review, user: sarah, video: video)
      expect(review.video_title).to eq "Monk"
    end
  end
end
