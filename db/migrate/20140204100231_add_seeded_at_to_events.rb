class AddSeededAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :seeded_at, :datetime
  end
end
