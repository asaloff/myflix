require 'spec_helper'

describe RelationshipsController do
  before { set_current_user }

  describe 'GET index' do
    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end

    it 'sets @relationships to the users the current user is following' do
      sarah = current_user
      bob = Fabricate(:user)
      frank = Fabricate(:user)
      relationship1 = Fabricate(:relationship, user: sarah, following: bob)
      relationship2 = Fabricate(:relationship, user: sarah, following: frank)
      get :index
      expect(assigns(:relationships)).to eq sarah.relationships
    end
  end

  describe 'DELETE destroy' do
    before { set_current_user }

    context 'with an unauthenticated user' do
      it_behaves_like "require_sign_in" do
        let(:action) { delete :destroy, id: 1 }
      end
    end

    context 'with an authenticated user' do
      let(:sarah) { current_user }
      let(:bob) { Fabricate(:user) }
      let(:frank) { Fabricate(:user) }

      it 'should redirect to the people page' do
        relationship1 = Fabricate(:relationship, user: sarah, following: bob)
        delete :destroy, id: relationship1.id
        expect(response).to redirect_to people_path
      end

      it 'destroys the relationship if the current user is the follower' do
        relationship1 = Fabricate(:relationship, user: sarah, following: bob)
        relationship2 = Fabricate(:relationship, user: sarah, following: frank)
        delete :destroy, id: relationship1.id
        expect(sarah.relationships.size).to eq(1)
      end

      it 'does not destroy the relationship if the current user is not the follower' do
        relationship1 = Fabricate(:relationship, user: frank, following: bob)
        delete :destroy, id: relationship1.id
        expect(Relationship.all.size).to eq(1)
      end
    end
  end

  describe "POST create" do
    before { set_current_user }

    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    it "redirects to the followed user's page" do
      bob = Fabricate(:user)
      post :create, following_id: bob.id
      expect(response).to redirect_to bob
    end

    it "creates a relationship where the current signed in user is following the selected user" do
      sarah = current_user
      bob = Fabricate(:user)
      post :create, following_id: bob.id
      expect(sarah.relationships.size).to eq(1)
      expect(bob.followers).to eq([sarah])
      expect(sarah.followings).to eq([bob])
    end

    it "does not create the relationship if the current user is already following the selected user" do
      sarah = current_user
      bob = Fabricate(:user)
      Fabricate(:relationship, user: sarah, following: bob)
      post :create, following_id: bob.id
      expect(sarah.relationships.size).to eq(1)
      expect(Relationship.all.size).to eq(1)
    end

    it "does not allow a user to follow themselves" do
      sarah = current_user
      post :create, following_id: sarah.id
      expect(sarah.followings.size).to eq(0)
    end
  end
end
