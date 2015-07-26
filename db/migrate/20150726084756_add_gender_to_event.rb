class AddGenderToEvent < ActiveRecord::Migration
  def change
    add_column :events, :gender, :string
  end
end
