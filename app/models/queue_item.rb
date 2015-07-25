class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :user, :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review = video.reviews.where(user: user).first
    review.rating if review
  end

  def category_name
    category.title
  end
end
