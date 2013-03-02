class AddUserIdToSwimmers < ActiveRecord::Migration
  def self.up
    add_column :swimmers, :user_id, :int
  end

  def self.down
    remove_column :swimmers, :user_id
  end
end
