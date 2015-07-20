class RenameSymbolInClubToCode < ActiveRecord::Migration
  def up
    rename_column :clubs, :symbol, :code
  end

  def down
    rename_column :clubs, :code, :symbol
  end
end
