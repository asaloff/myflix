require 'spec_helper'

describe ResetPasswordsController do
  describe 'GET show' do
    context 'with a valid password token' do
      it 'sets @user' do
        sarah = Fabricate(:user, password_token: "12345")
        get :show, id: sarah.password_token
        expect(assigns(:user)).to eq sarah
      end
    end

    context 'with an invalid password token' do
      it 'redirects to the invalid token page' do
        get :show, id: "12345"
        expect(response).to redirect_to expired_link_path
      end
    end
  end

  describe 'POST update' do
    context 'with valid input' do
      it 'redirects to the sign in page' do
        sarah = Fabricate(:user, password: "old_password", password_token: "12345")
        post :update, id: sarah.password_token, user: { password: "new_password" }
        expect(response).to redirect_to login_path
      end

      it 'updates the users password' do
        sarah = Fabricate(:user, password: "old_password", password_token: "12345")
        post :update, id: sarah.password_token, user: { password: "new_password" }
        expect(sarah.reload.authenticate("new_password")).to be_truthy
      end

      it 'destroys the password token' do
        sarah = Fabricate(:user, password: "old_password", password_token: "12345")
        post :update, id: sarah.password_token, user: { password: "new_password" }
        expect(sarah.reload.password_token).to be_nil
      end
    end

    context 'with invalid input' do
      it 'redirects to the show page' do
        sarah = Fabricate(:user, password: "old_password", password_token: "12345")
        post :update, id: sarah.password_token, user: { password: "" }
        expect(response).to redirect_to reset_password_path(sarah.password_token)
      end

      it 'sets the error message' do
        sarah = Fabricate(:user, password: "old_password", password_token: "12345")
        post :update, id: sarah.password_token, user: { password: "" }
        expect(flash["danger"]).to be_present
      end
    end
  end
end