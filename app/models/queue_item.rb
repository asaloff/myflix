class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :user, :video
  validates_numericality_of :position, only_integer: true

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.new(video: video, user: user, rating: new_rating)
      review.save(validate: false)
    end
  end

  def category_name
    category.title
  end

  private

  def review
    @review ||= video.reviews.find_by(user: user)
  end
end
