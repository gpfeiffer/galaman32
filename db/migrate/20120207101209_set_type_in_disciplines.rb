class SetTypeInDisciplines < ActiveRecord::Migration
  def self.up
    Discipline.all.each do |discipline|
      discipline.update_attribute(:type, Discipline::TYPES.first)
    end
  end

  def self.down
    Discipline.all.each do |discipline|
      discipline.update_attribute(:type, nil)
    end
  end
end
