class AddCourseToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :course, :string
  end
end
