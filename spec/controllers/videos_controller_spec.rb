require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    let(:video) { Fabricate(:video) }

    before { set_current_user }

    it_behaves_like 'sets @video' do
      let(:action) { get :show, id: video.id }
    end
    
    it 'sets @reviews variable when the user is authenticated' do
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it 'sorts the reviews in order of newest first' do
      review1 = Fabricate(:review, video: video, created_at: 3.day.ago)
      review2 = Fabricate(:review, video: video, created_at: 1.day.ago)
      review3 = Fabricate(:review, video: video, created_at: 2.day.ago)
      get :show, id: video.id
      expect(assigns(:reviews)).to eq([review2, review3, review1])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: video.id }
    end

    it_behaves_like "require_active" do
      let(:action) { get :show, id: video.id }
    end
  end

  describe 'GET search' do
    it 'sets @videos variable when the user is authenticated' do
      set_current_user
      futurama = Fabricate(:video, title: 'Futurama')
      get :search, search: 'rama'
      expect(assigns(:videos)).to eq([futurama])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :search, search: 'rama' }
    end

    it_behaves_like "require_active" do
      let(:action) { get :search, search: 'rama' }
    end
  end
end