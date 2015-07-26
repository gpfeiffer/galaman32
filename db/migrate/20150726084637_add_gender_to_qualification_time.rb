class AddGenderToQualificationTime < ActiveRecord::Migration
  def change
    add_column :qualification_times, :gender, :string
  end
end
