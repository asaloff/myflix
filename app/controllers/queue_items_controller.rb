class QueueItemsController < ApplicationController
  before_action :require_user
  
  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.has_queue_item(queue_item)
    normalize_positions
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      normalize_positions
    rescue ActiveRecord::RecordInvalid
      flash["danger"] = "Invalid position number"
    end
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    QueueItem.create(video: video, user: current_user, position: current_user.next_position_available) unless current_user.already_queued?(video)
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data["id"])
        if queue_item.user == current_user
          queue_item.update_attributes!(position: queue_item_data["position"]) 
        end
      end
    end
  end

  def normalize_positions
    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end
end
