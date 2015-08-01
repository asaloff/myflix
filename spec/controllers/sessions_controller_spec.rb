require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    it 'redirects to the home page for authenticated users' do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe 'POST create' do
    context 'with valid credentials' do
      let(:bob) { Fabricate(:user, password: 'password') }
      before { post :create, email: bob.email, password: bob.password }

      it 'sets the user to the session' do
        expect(session[:user_id]).to eq(bob.id)
      end

      it 'redirects to the home page' do
        expect(response).to redirect_to home_path
      end
    end

    context 'without valid credentials' do
      before { post :create }

      it 'does not put the signed in user in the session' do
        expect(session[:user_id]).to be_nil
      end

      it_behaves_like "require_sign_in" do
        let(:action) { nil }
      end

      it 'sets the flash message' do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe 'GET destroy' do
    before do
      set_current_user
      get :destroy
    end

    it 'clears the session for the user' do
      expect(session[:user_id]).to be_nil
    end

    it 'sets the flash message' do
      expect(flash['success']).not_to be_blank
    end

    it 'redirects to the front page' do
      expect(response).to redirect_to root_path
    end
  end
end
