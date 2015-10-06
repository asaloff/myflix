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
      expect(assigns(:user)).to be_a_new User
    end

    it 'logs out any signed in user' do
      set_current_user
      get :new
      expect(session[:user_id]).to be_nil
    end
  end

  describe 'GET new_with_invitation_token' do
    it 'logs out any signed in user' do
      set_current_user
      invitation = Fabricate(:invitation, inviter: Fabricate(:user))
      get :new_with_invitation_token, token: invitation.token
      expect(session[:user_id]).to be_nil
    end

    context 'with a valid invitation' do
      let(:sarah) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter: sarah) }
      before { get :new_with_invitation_token, token: invitation.token }

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'sets the @invitation variable' do
        expect(assigns(:invitation)).to eq invitation
      end

      it 'set @user to a new user' do
        expect(assigns(:user)).to be_a_new User
      end
    end

    context 'without a invitation' do
      it "redirects to the expired link path" do
        get :new_with_invitation_token, token: "12345"
        expect(response).to redirect_to expired_link_path
      end
    end
  end

  describe 'POST create' do
    after do
      ActionMailer::Base.deliveries.clear 
    end

    context 'with successful signup' do
      let(:result) { double(:result, successful?: true) }

      before do
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'redirects to sign in' do
        expect(response).to redirect_to login_path
      end
    end

    context "with valid personal info, valid card, and has invitation" do
      let(:sarah) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter: sarah) }
      let(:result) { double(:result, successful?: true) }

      it "sets @invitation" do
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), invitation_token: invitation.token
        expect(assigns(:invitation)).to eq invitation
      end
    end

    context "with valid personal info and declined card" do
      let(:result) { double(:result, successful?: false, error_message: "Card declined") }

      before do
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user)).to be_present
      end

      it "sets the flash error message" do
        expect(flash["danger"]).to be_present
      end
    end

    context 'with invalid personal info' do
      before do
        post :create, user: Fabricate.attributes_for(:user, email: '')
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
