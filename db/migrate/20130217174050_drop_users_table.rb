class DropUsersTable < ActiveRecord::Migration
  def self.up
    drop_table :users
  end

  def self.down
    create_table :users do |t|
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.string :email
      t.boolean :admin, :default => false
      t.boolean :senior, :default => false

      t.timestamps
    end
  end
end
