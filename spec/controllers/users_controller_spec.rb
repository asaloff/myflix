require 'spec_helper'

describe UsersController do
  describe 'GET show' do
    let(:sarah) { Fabricate(:user) }
    before { set_current_user }
    
    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: sarah }
    end

    it 'sets @user' do
      get :show, id: sarah
      expect(assigns(:user)).to eq sarah
    end
  end

  describe 'GET new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST create' do
    context 'with valid user' do
      before { post :create, user: Fabricate.attributes_for(:user) }

      it 'saves the user' do
        expect(User.count).to eq(1)
      end

      it 'redirects to sign in' do
        expect(response).to redirect_to login_path
      end
    end

    context 'with invalid user' do
      before { post :create, user: Fabricate.attributes_for(:user, email: '') }

      it 'does not save the user' do
        expect(User.all).to be_empty
      end

      it 'renders the :new template' do
        expect(response).to render_template(:new)
      end

      it 'sets @user' do
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end
end
