require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "with authenticated user" do
      let(:current_user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }

      before do
        session[:user_id] = current_user.id
     end

      context "with valid inputs" do
        before do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end

        it "redirects to the video's page" do
          expect(response).to redirect_to video
        end

        it "sets @video" do
          expect(assigns(:video)).to eq(video)
        end

        it "creates a new review" do
          expect(Review.count).to eq(1)
        end

        it "creates a new review associated with the video" do
          expect(video.reviews.count).to eq(1) 
        end

        it "creates a new review associated with the current_user" do
          expect(Review.first.user).to eq(current_user)
        end
      end

      context "with invalid inputs" do
        it "does not save the review" do
          post :create, review: { rating: 5 }, video_id: video.id
          expect(Review.count).to eq(0)
        end

        it "renders the video/show template" do
          post :create, review: { rating: 5 }, video_id: video.id
          expect(response).to render_template "videos/show"
        end

        it "sets @video" do
          post :create, review: { rating: 5 }, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end

        it "sets @reviews" do
          review = Fabricate(:review, video: video)
          post :create, review: { rating: 5 }, video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

    context "with unauthenticated user" do
      it "redirects to login" do
        video = Fabricate(:video)
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to login_path
      end
    end
  end
end
