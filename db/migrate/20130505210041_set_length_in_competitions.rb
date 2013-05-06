class SetLengthInCompetitions < ActiveRecord::Migration
  def self.up
    Competition.all.each do |competition|
      competition.update_attribute(:length, 1)
    end
  end

  def self.down
    Competition.all.each do |competition|
      competition.update_attribute(:length, nil)
    end
  end
end
