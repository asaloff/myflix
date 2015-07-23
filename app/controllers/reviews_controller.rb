class ReviewsController < ApplicationController
  before_action :require_user
  
  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.build(review_params)

    if review.save
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      render "videos/show"
    end 
  end

  def review_params
    params.require(:review).permit(:rating, :content).merge!(user: current_user)
  end
end
