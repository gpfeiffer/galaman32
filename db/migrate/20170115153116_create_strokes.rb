class CreateStrokes < ActiveRecord::Migration
  def change
    create_table :strokes do |t|
      t.string :name
      t.string :short
      t.integer :code

      t.timestamps
    end
  end
end
