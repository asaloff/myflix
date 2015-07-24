module ApplicationHelper

  def average_rating
    @reviews.average(:rating).round(1).to_s + ' / 5.0'
  end

  def num_of_stars
    [5,4,3,2,1].map { |num| [pluralize(num, 'Star'), num.to_i] }
  end
end
