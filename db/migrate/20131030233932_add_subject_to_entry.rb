class AddSubjectToEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :subject_id, :integer
    add_column :entries, :subject_type, :string
  end

  def self.down
    remove_column :entries, :subject_type
    remove_column :entries, :subject_id
  end
end
