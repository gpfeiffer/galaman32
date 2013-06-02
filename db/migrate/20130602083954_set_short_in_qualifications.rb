class SetShortInQualifications < ActiveRecord::Migration
  def self.up
    Qualification.all.each do |qualification|
      qualification.short =  qualification.name
    end
  end

  def self.down
  end
end
