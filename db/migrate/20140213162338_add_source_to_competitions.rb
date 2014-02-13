class AddSourceToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :source, :string
    add_column :competitions, :source_url, :string
    add_column :competitions, :source_date, :date
  end
end
