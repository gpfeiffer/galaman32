class AddSourceUrlAndSourceDateToQualifications < ActiveRecord::Migration
  def self.up
    add_column :qualifications, :source_url, :string
    add_column :qualifications, :source_date, :date
  end

  def self.down
    remove_column :qualifications, :source_date
    remove_column :qualifications, :source_url
  end
end
