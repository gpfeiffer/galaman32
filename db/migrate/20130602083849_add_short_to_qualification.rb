class AddShortToQualification < ActiveRecord::Migration
  def self.up
    add_column :qualifications, :short, :string
  end

  def self.down
    remove_column :qualifications, :short
  end
end
