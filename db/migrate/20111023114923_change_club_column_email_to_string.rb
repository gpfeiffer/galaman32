class ChangeClubColumnEmailToString < ActiveRecord::Migration
  def self.up
    change_column :clubs, :email, :string
  end

  def self.down
    change_column :clubs, :email, :text
  end
end
