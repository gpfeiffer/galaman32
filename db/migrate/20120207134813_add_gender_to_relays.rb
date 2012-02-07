class AddGenderToRelays < ActiveRecord::Migration
  def self.up
    add_column :relays, :gender, :string
  end

  def self.down
    remove_column :relays, :gender
  end
end
