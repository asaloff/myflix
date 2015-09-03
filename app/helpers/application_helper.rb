module ApplicationHelper
  def options_for_num_of_stars(selected=nil)
    options_for_select([5,4,3,2,1].map { |num| [pluralize(num, 'Star'), num] }, selected)
  end

  def not_able_to_follow(user)
    current_user.followings.include?(user) || user == current_user
  end
end
