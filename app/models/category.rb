class Category < ActiveRecord::Base
  has_many :videos, -> { order("title")}

  validates_uniqueness_of :title
end