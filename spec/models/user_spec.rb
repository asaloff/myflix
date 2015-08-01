require 'spec_helper'

describe User do
  it { should have_many :reviews }
  it { should have_many(:queue_items).order('position') }
  it { should have_secure_password }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :full_name }
  it { should validate_uniqueness_of :email }

  describe '#has_queue_item(queue_item)' do
    let(:sarah) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it 'returns true if the user has the item queued' do
      queue_item = Fabricate(:queue_item, user: sarah, video: video)
      expect(sarah.has_queue_item(queue_item)).to be true
    end
    it 'returns false if the user does not have the item queued' do
      queue_item = Fabricate(:queue_item, user: Fabricate(:user),video: video)
      expect(sarah.has_queue_item(queue_item)).to be false
    end
  end

  describe '#next_position_available' do
    it 'returns the next position available in the users queue' do
      sarah = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: sarah, video: Fabricate(:video))
      expect(sarah.next_position_available).to eq(2) 
    end
  end

  describe '#already_queued?(video)' do
    let(:sarah) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it "returns true if the video is already in the user's queue" do
      queue_item = Fabricate(:queue_item, user: sarah, video: video)
      expect(sarah.already_queued?(video)).to be true
    end

    it "returns false if the video is not in the user's queue" do
      expect(sarah.already_queued?(video)).to be false
    end
  end
end
