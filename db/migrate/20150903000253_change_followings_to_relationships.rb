class ChangeFollowingsToRelationships < ActiveRecord::Migration
  def change
    rename_table :followings, :relationships
  end
end
