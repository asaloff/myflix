require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    before { set_current_user }

    it "sets @queue_items to the signed in user's queue_items" do
      queue_item1 = Fabricate(:queue_item, user: current_user, video: Fabricate(:video))
      queue_item2 = Fabricate(:queue_item, user: current_user, video: Fabricate(:video))
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end

    it_behaves_like "require_active" do
      let(:action) { get :index }
    end
  end

  describe 'POST create' do
    before { set_current_user }

    let(:video) { Fabricate(:video) }

    it_behaves_like "send_to_my_queue" do
      let(:action) { post :create, video_id: video.id }
    end

    it "creates a new queue item" do
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates a new queue item associated with the video" do
      post :create, video_id: video.id
      expect(QueueItem.last.video).to eq(video)
    end

    it "creates a new queue item associated with the logged in user" do
      post :create, video_id: video.id
      expect(QueueItem.last.user).to eq(current_user)
    end

    it "it puts the queue item as the last position in the queue" do
      video2 = Fabricate(:video)
      Fabricate(:queue_item, user: current_user, video: video2)
      post :create, video_id: video.id
      expect(QueueItem.last.position).to eq(2)
    end

    it "does not add the queue item if it is already in the queue" do
      Fabricate(:queue_item, video: video, user: current_user)
      post :create, video_id: video.id
      expect(current_user.queue_items.count).to eq (1)
    end

    it_behaves_like "require_sign_in" do
      let(:action) { post :create, video_id: 3 }
    end

    it_behaves_like "require_active" do
      let(:action) { post :create, video_id: 3 }
    end
  end

  describe 'DELETE destroy' do
    before { set_current_user }

    let(:video) { Fabricate(:video) }
    let!(:queue_item) { Fabricate(:queue_item, video: video, user: current_user) }

    it_behaves_like "send_to_my_queue" do
      let(:action) { delete :destroy, id: queue_item.id }
    end

    it 'destroys the queue item' do
      delete :destroy, id: queue_item.id
      expect(current_user.queue_items.count).to eq(0)
    end

    it "normalizes the position of the remaining queue items" do
      queue_item2 = Fabricate(:queue_item, user: current_user, video: video, position: 2)
      delete :destroy, id: queue_item.id
      expect(queue_item2.reload.position).to eq(1)
    end

    it "does not delete the queue item if it is not in current users queue" do
      fred = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: fred)
      delete :destroy, id: queue_item.id
      expect(fred.queue_items.count).to eq(1)
    end

    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: queue_item.id }
    end

    it_behaves_like "require_active" do
      let(:action) { delete :destroy, id: queue_item.id }
    end
  end

  describe 'POST update_queue' do
    before { set_current_user }
    
    context "with queue items that belong to the current user" do
       let(:queue_item1) { Fabricate(:queue_item, user: current_user, video: Fabricate(:video), position: 1) }
        let(:queue_item2) { Fabricate(:queue_item, user: current_user, video: Fabricate(:video), position: 2) }

      context "with valid inputs" do
        before { post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}] }

        it_behaves_like "send_to_my_queue" do
          let(:action) { nil }
        end

        it "reorders the queue items" do
          expect(current_user.queue_items).to eq([queue_item2, queue_item1])
        end

        it "updates the queue item's positions" do
          expect(current_user.queue_items.map(&:position)).to eq([1, 2])
        end
      end

      context "with invalid inputs" do
        it_behaves_like "send_to_my_queue" do
          let(:action) { post :update_queue, queue_items: [{id: queue_item1.id, position: 3.1}, {id: queue_item2.id, position: 1}] }
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

      it_behaves_like "require_sign_in" do
        let(:action) { post :update_queue, queue_items: [{id: 1, position: 3}, {id: 2, position: 2}] }
      end
      
      it_behaves_like "require_active" do
        let(:action) { post :update_queue, queue_items: [{id: 1, position: 3}, {id: 2, position: 2}] }
      end
    end

    context "with queue items that do not belong to the current user" do
      let(:fred) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: fred, video: Fabricate(:video), position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: current_user, video: Fabricate(:video), position: 2) }
      
      it_behaves_like "send_to_my_queue" do
        let(:action) { post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}] }
      end

      it "does not save the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end
