class AddLscToClub < ActiveRecord::Migration
  def change
    add_column :clubs, :lsc, :string, :default => ""
  end
end
