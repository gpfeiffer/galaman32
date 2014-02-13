class AddStageToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :stage, :string
  end
end
