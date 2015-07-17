class AddFieldsToResult < ActiveRecord::Migration
  def change
    add_column :results, :heat, :integer
    add_column :results, :lane, :integer
    add_column :results, :stage, :string
  end
end
