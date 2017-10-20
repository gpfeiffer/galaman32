class AddAgeUpToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :age_up, :date
  end
end
