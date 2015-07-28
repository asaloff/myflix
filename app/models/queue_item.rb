class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :user, :video
  validates_numericality_of :position, only_integer: true

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review = video.reviews.find_by(user: user)
    review.rating if review
  end

  def category_name
    category.title
  end
end
