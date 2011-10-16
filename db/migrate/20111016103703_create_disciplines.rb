class CreateDisciplines < ActiveRecord::Migration
  def self.up
    create_table :disciplines do |t|
      t.string :gender
      t.integer :distance
      t.string :course
      t.string :stroke

      t.timestamps
    end
  end

  def self.down
    drop_table :disciplines
  end
end
