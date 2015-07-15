class Video < ActiveRecord::Base
  belongs_to :category

  validates_presence_of :title, :description
  validates_uniqueness_of :title

  def self.search_by_title(search_input)
    return [] if search_input == ''
    where("lower(title) LIKE ?", "%#{search_input.downcase}%").sort_by { |vid| vid.created_at }
  end
end