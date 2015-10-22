class Review < ActiveRecord::Base
  belongs_to :video, touch: true
  belongs_to :user

  validates_presence_of :rating, :content, :video

  delegate :title, to: :video, prefix: :video
end
