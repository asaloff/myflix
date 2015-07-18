class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :full_name, :password_digest
      t.timestamps
    end
  end
end
