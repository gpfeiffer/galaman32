class MoveGenderOutOfDiscipline < ActiveRecord::Migration
  def up
    Event.all.each do |event|
      event.update_attribute(:gender, event.discipline.gender)
    end

    QualificationTime.all.each do |qt|
      qt.update_attribute(:gender, qt.discipline.gender)
    end
  end

  def down
  end
end
