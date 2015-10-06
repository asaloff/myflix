class VideoDecorator < Draper::Decorator
  delegate_all

  def display_rating
    object.reviews.any? ? "Average Rating: #{object.average_rating} / 5" : "N/A"
  end
end
