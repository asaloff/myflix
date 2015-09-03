class CreateFrienships < ActiveRecord::Migration
  def change
    create_table :frienships do |t|
      t.integer :user_id, :follower_id
      t.timestamps
    end
  end
end
