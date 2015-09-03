class ChangeFollowedsToFollowings < ActiveRecord::Migration
  def change
    rename_column :relationships, :followed_id, :following_id
  end
end
