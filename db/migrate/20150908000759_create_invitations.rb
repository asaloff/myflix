class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :invitee_name, :invitee_email
      t.text :message
      t.integer :inviter_id
      t.timestamps
    end
  end
end
