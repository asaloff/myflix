class Category < ActiveRecord::Base
  has_many :videos, -> { order('created_at desc') }

  validates_uniqueness_of :title
  validates_presence_of :title

  def recent_videos
    videos.limit(6)
  end
end