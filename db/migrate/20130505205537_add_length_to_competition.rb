class AddLengthToCompetition < ActiveRecord::Migration
  def self.up
    add_column :competitions, :length, :integer
  end

  def self.down
    remove_column :competitions, :length
  end
end
