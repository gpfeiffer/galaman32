class AddStageToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :stage, :string
  end

  def self.down
    remove_column :events, :stage
  end
end
