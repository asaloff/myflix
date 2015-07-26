require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it "sets @queue_items to the signed in user's queue_items" do
      sarah = Fabricate(:user)
      session[:user_id] = sarah.id
      queue_item1 = Fabricate(:queue_item, user: sarah, video: Fabricate(:video))
      queue_item2 = Fabricate(:queue_item, user: sarah, video: Fabricate(:video))
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to login_path
    end
  end

  describe 'POST create' do
    it "redirects to the my queue page" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a new queue item" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates a new queue item associated with the video" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.last.video).to eq(video)
    end

    it "creates a new queue item associated with the logged in user" do
      sarah = Fabricate(:user)
      session[:user_id] = sarah.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.last.user).to eq(sarah)
    end

    it "it puts the queue item as the last position in the queue" do
      sarah = Fabricate(:user)
      session[:user_id] = sarah.id
      video = Fabricate(:video)
      video2 = Fabricate(:video)
      Fabricate(:queue_item, user: sarah, video: video2)
      post :create, video_id: video.id
      expect(QueueItem.last.position).to eq(2)
    end

    it "does not add the queue item if it is already in the queue" do
      sarah = Fabricate(:user)
      session[:user_id] = sarah.id
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video, user: sarah)
      post :create, video_id: video.id
      expect(sarah.queue_items.count).to eq (1)
    end

    it "redirects to the login path for unauthenticated users" do
      post :create, video_id: 3
      expect(response).to redirect_to login_path
    end
  end

  describe 'DELETE destroy' do
    let(:sarah) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:queue_item) { Fabricate(:queue_item, video: video, user: sarah) }

    before do
      session[:user_id] = sarah.id
    end

    it 'redirects to the my queue page' do
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it 'destroys the queue item' do
      delete :destroy, id: queue_item.id
      expect(sarah.queue_items.count).to eq(0)
    end

    it "does not delete the queue item if it is not in current users queue" do
      fred = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: fred)
      delete :destroy, id: queue_item.id
      expect(fred.queue_items.count).to eq(1)
    end

    it "redirects to the sign in page for unauthenticated users" do
      session[:user_id] = nil
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to login_path
    end
  end
end
