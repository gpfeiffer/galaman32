class SetTempInEntry < ActiveRecord::Migration
  def self.up
    Heat.all.each do |heat|
      heat.entries.each do |entry|
        entry.update_attribute(:temp, heat.pos)
      end
    end
  end

  def self.down
    Heat.all.each do |heat|
      heat.entries.each do |entry|
        entry.update_attribute(:temp, nil)
      end
    end
  end
end
