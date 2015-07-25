require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it "sets @queue_items to the signed in user's queue_items" do
      sarah = Fabricate(:user)
      session[:user_id] = sarah.id
      video = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, user: sarah, video: video)
      queue_item2 = Fabricate(:queue_item, user: sarah, video: video)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to login_path
    end
  end
end
