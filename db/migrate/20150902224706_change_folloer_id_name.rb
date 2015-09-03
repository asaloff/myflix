class ChangeFolloerIdName < ActiveRecord::Migration
  def change
    rename_column :followings, :follower_id, :followed_id
  end
end
