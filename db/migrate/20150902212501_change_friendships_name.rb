class ChangeFriendshipsName < ActiveRecord::Migration
  def change
    rename_table :friendships, :followings
  end
end
