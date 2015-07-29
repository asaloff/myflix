class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order('position') }
  
  has_secure_password validations: false

  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  def has_queue_item(queue_item)
    queue_items.include?(queue_item)
  end

  def next_position_available
    queue_items.count + 1
  end

  def already_queued?(video)
    queue_items.map(&:video).include?(video)
  end

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end
end