class RemoveGenderFromQualificationTime < ActiveRecord::Migration
  def self.up
    remove_column :qualification_times, :gender
  end

  def self.down
    add_column :qualification_times, :gender, :string
  end
end
