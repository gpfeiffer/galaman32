class CreateSplits < ActiveRecord::Migration
  def change
    create_table :splits do |t|
      t.integer :time
      t.integer :length
      t.integer :result_id

      t.timestamps
    end
  end
end
