module ApplicationHelper
  def options_for_num_of_stars(selected=nil)
    options_for_select([5,4,3,2,1].map { |num| [pluralize(num, 'Star'), num] }, selected)
  end
end
