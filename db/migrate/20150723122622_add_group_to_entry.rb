class AddGroupToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :group, :integer, default: 99
  end
end
