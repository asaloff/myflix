class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }

  validates_presence_of :title, :description
  validates_uniqueness_of :title

  def self.search_by_title(search_input)
    return [] if search_input == ''
    where("title ILIKE ?", "%#{search_input}%").order("created_at")
  end

  def average_rating
    reviews.average(:rating).round(1)
  end
end
