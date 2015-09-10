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
    after { ActionMailer::Base.deliveries.clear }

    context 'with valid inputs' do
      before { post :create, user: Fabricate.attributes_for(:user) }

      it 'saves the user' do
        expect(User.count).to eq(1)
      end

      context 'email sending' do
        it 'sends the email' do
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it 'sends out email to the right recipient' do
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq([controller.params[:user][:email]])
        end

        it 'has the right contents' do
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to include(controller.params[:user][:full_name])
        end
      end

      it 'redirects to sign in' do
        expect(response).to redirect_to login_path
      end
    end

    context "with valid inputs and has invitation" do
      let(:sarah) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter: sarah) }
      before { post :create, user: Fabricate.attributes_for(:user), invitation_token: invitation.token }

      it "sets @invitation" do
        expect(assigns(:invitation)).to eq invitation
      end

      it "sets the new user's inviter" do
        expect(User.last.inviter_id).to eq sarah.id
      end

      it "has the new user follow the inviter" do
        expect(User.last.followings).to eq [sarah]
      end

      it "has the inviter follow the new user" do
        expect(User.last.followers).to eq [sarah]
      end

      it "destroys the invitation" do
        expect(Invitation.all.size).to eq(0)
      end
    end

    context 'with invalid inputs' do
      before { post :create, user: Fabricate.attributes_for(:user, email: '') }

      it 'does not save the user' do
        expect(User.all).to be_empty
      end

      it 'does not send out the email' do
        expect(ActionMailer::Base.deliveries).to be_empty
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
