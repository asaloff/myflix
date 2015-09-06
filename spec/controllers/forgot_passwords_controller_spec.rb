require 'spec_helper'

describe ForgotPasswordsController do
  describe 'POST create' do
    after { ActionMailer::Base.deliveries.clear }

    context 'with a known email address' do
      it 'redirects to the sent reset email page' do
        sarah = Fabricate(:user, email: 'sarah@example.com')
        post :create, email: 'sarah@example.com'
        expect(response).to redirect_to sent_email_reset_path
      end

      it 'sends the email to the user' do
        sarah = Fabricate(:user, email: 'sarah@example.com')
        post :create, email: 'sarah@example.com'
        expect(ActionMailer::Base.deliveries.last.to).to eq(['sarah@example.com'])
      end

      it 'creates a password token for the user' do
        sarah = Fabricate(:user, email: 'sarah@example.com')
        post :create, email: 'sarah@example.com'
        expect(sarah.reload.password_token).to be_present
      end
    end

    context 'with no email input' do
      it 'redirects to the forgot password path' do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end

      it 'sets the error message' do
        post :create, email: ''
        expect(flash["danger"]).to eq "You must enter an email address"
      end
    end

    context 'with an unknown email address' do
      it 'redirects to the forgot password path' do
        post :create, email: 'foo@example.com'
        expect(response).to redirect_to forgot_password_path
      end

      it 'sets the error message' do
        post :create, email: 'foo@example.com'
        expect(flash["danger"]).to eq "The email address you entered is not in our system"
      end
    end
  end
end