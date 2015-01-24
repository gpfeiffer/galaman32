class AddDifferentialToDiscipline < ActiveRecord::Migration
  def change
    add_column :disciplines, :differential, :integer
  end
end
