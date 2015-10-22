require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like 'require_sign_in' do
      let(:action) { get :new }
    end

    it_behaves_like 'require_admin' do
      let(:action) { get :new }
    end

    it_behaves_like "require_active" do
      let(:action) { get :new }
    end

    it 'sets @video to a new video' do
      set_current_admin_user
      get :new
      expect(assigns(:video)).to be_a_new Video
    end
  end

  describe "POST create" do
    let(:category) { Fabricate(:category) }

    it_behaves_like 'require_sign_in' do
      let(:action) { post :create }
    end

    it_behaves_like 'require_admin' do
      let(:action) { post :create }
    end

    it_behaves_like "require_active" do
      let(:action) { post :create }
    end

    context "with valid inputs" do
      before do
        set_current_admin_user
        post :create, video: { title: "Monk", description: "Great show", category_id: category }
      end

      it "redirects to the admin add video page" do
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates a new video" do
        expect(category.videos.size).to eq(1)
      end

      it "sets the success flash message" do
        expect(flash["success"]).to be_present
      end
    end

    context "with invalid inputs" do
      before do
        set_current_admin_user
        post :create, video: { title: "", description: "Great show", category: category }
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets the @video variable" do
        expect(assigns(:video)).to be_present
      end

      it "doesn't save the video" do
        expect(category.videos.size).to eq(0)
      end
    end
  end
end
