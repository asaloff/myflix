require 'spec_helper'

describe InvitationsController  do
  describe 'GET new' do
    before { set_current_user }

    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it 'sets @invitation to a new invitation' do
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end
  end

  describe 'POST create' do
    before do
     set_current_user
     ActionMailer::Base.deliveries.clear
   end

    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    context 'with valid inputs' do
      before { post :create, invitation: Fabricate.attributes_for(:invitation, invitee_email: "friend@example.com", inviter: current_user) }

      it 'redirects to the new invitation page' do
        expect(response).to redirect_to new_invitation_path
      end

      it 'sets the success flash message' do
        expect(flash["success"]).to be_present
      end

      it 'creates a new invitation' do
        expect(Invitation.all.size).to eq(1)
      end

      it 'sends an email to the friend' do
        expect(ActionMailer::Base.deliveries.first.to).to eq ["friend@example.com"]
      end
    end

    context 'with invalid inputs' do
      before { post :create, invitation: Fabricate.attributes_for(:invitation, invitee_email: "") }

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'does not save the invitation' do
        expect(Invitation.all.size).to eq(0)
      end

      it 'does not send the email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end