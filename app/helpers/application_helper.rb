module ApplicationHelper
  def options_for_num_of_stars(selected=nil)
    options_for_select([5,4,3,2,1].map { |num| [pluralize(num, 'Star'), num] }, selected)
  end

  def options_for_categories
    Category.all.collect {|c| [ c.title, c.id ] }
  end

  def current_user_can_follow?(user)
    true unless current_user.followings.include?(user) || user == current_user
  end

  def options_for_search_rating(params)
    options_for_select((10..50).map { |num| num / 10.0 }, params)
  end
end
