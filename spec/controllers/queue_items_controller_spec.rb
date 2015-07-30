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

    it "normalizes the position of the remaining queue items" do
      queue_item2 = Fabricate(:queue_item, user: sarah, video: video, position: 2)
      delete :destroy, id: queue_item.id
      expect(queue_item2.reload.position).to eq(1)
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

  describe 'POST update_queue' do
    context "with valid inputs" do
      let(:sarah) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: sarah, video: Fabricate(:video), position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: sarah, video: Fabricate(:video), position: 2) }

      before do 
        session[:user_id] = sarah.id
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
      end

      it "redirects to the my queue page" do
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        expect(sarah.queue_items).to eq([queue_item2, queue_item1])
      end

      it "updates the queue item's positions" do
        expect(sarah.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid inputs" do
      let(:sarah) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: sarah, video: Fabricate(:video), position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: sarah, video: Fabricate(:video), position: 2) }

      before do
        session[:user_id] = sarah.id
      end

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.1}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash method" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.1}, {id: queue_item2.id, position: 1}]
        expect(flash["danger"]).to be_present
      end

      it "does not update the queue" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.4}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with unauthenticated user" do
      it "redirects to login_path" do
        post :update_queue, queue_items: [{id: 1, position: 3}, {id: 2, position: 2}]
        expect(response).to redirect_to login_path
      end
    end

    context "with queue items that do not belong to the current user" do
      let(:sarah) { Fabricate(:user) }
      let(:fred) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: fred, video: Fabricate(:video), position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: sarah, video: Fabricate(:video), position: 2) }

      before do
        session[:user_id] = sarah.id
      end
      
      it "redirects to the my queue path" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "does not save the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end
