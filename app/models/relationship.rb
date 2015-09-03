class Relationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :following, class_name: 'User'

  validates_uniqueness_of :user, scope: :following
  validate :cannot_follow_self

  private

  def cannot_follow_self
    if user_id == following_id
      errors.add(:following_id, "can't follow yourself")
    end
  end
end