class Category < ActiveRecord::Base
  has_many :videos, -> { order("title")}

  validates :title, uniqueness: true
end