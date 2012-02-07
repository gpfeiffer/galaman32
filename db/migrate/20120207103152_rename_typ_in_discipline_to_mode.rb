class RenameTypInDisciplineToMode < ActiveRecord::Migration
  def self.up
    rename_column :disciplines, :type, :mode
  end

  def self.down
    rename_column :disciplines, :mode, :type
  end
end
