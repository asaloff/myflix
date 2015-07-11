class Category < ActiveRecord::Base
  has_many :videos

  validates :title, uniqueness: true
end