module ApplicationHelper
  def num_of_stars
    [5,4,3,2,1].map { |num| [pluralize(num, 'Star'), num] }
  end
end
