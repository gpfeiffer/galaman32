class AddSourceToQualifications < ActiveRecord::Migration
  def self.up
    add_column :qualifications, :source, :string
  end

  def self.down
    remove_column :qualifications, :source
  end
end
