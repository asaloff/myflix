require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    it 'sets @video variable when the user is authenticated' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
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