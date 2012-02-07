class AddTypeToDisciplines < ActiveRecord::Migration
  def self.up
    add_column :disciplines, :type, :string
  end

  def self.down
    remove_column :disciplines, :type
  end
end
