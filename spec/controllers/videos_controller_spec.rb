require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    it 'sets @video variable when the user is authenticated' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
    
    it 'sets @reviews variable when the user is authenticated' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it 'sorts the reviews in order of newest first' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video, created_at: 3.day.ago)
      review2 = Fabricate(:review, video: video, created_at: 1.day.ago)
      review3 = Fabricate(:review, video: video, created_at: 2.day.ago)
      get :show, id: video.id
      expect(assigns(:reviews)).to eq([review2, review3, review1])
    end

    it 'redirects to login when the user is unauthenticated' do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to login_path
    end
  end

  describe 'GET search' do
      it 'sets @videos variable when the user is authenticated' do
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: 'Futurama')
      get :search, search: 'rama'
      expect(assigns(:videos)).to eq([futurama])
    end

    it 'redirects to login when the user is unauthenticated' do
      futurama = Fabricate(:video, title: 'Futurama')
      get :search, search: 'rama'
      expect(response).to redirect_to login_path
    end
  end
end