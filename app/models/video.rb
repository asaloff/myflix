class Video < ActiveRecord::Base
  belongs_to :category

  validates :title, uniqueness: true
end