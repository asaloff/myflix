require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it "sets @queue_items to the signed in user's queue_items" do
      sarah = Fabricate(:user)
      session[:user_id] = sarah.id
      video = Fabricate(:video)
      video2 = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, user: sarah, video: video)
      queue_item2 = Fabricate(:queue_item, user: sarah, video: video2)
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
      expect(assigns(:queue_item).video).to eq(video)
    end

    it "creates a new queue item associated with the logged in user" do
      sarah = Fabricate(:user)
      session[:user_id] = sarah.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(assigns(:queue_item).user).to eq(sarah)
    end

    it "it puts the queue item as the last position in the queue" do
      sarah = Fabricate(:user)
      session[:user_id] = sarah.id
      video = Fabricate(:video)
      video2 = Fabricate(:video)
      Fabricate(:queue_item, user: sarah, video: video2)
      post :create, video_id: video.id
      expect(assigns(:queue_item).position).to eq(2)
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
end
