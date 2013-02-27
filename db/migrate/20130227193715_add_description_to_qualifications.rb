class AddDescriptionToQualifications < ActiveRecord::Migration
  def self.up
    add_column :qualifications, :description, :text
  end

  def self.down
    remove_column :qualifications, :description
  end
end
