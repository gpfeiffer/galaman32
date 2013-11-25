class UpdateSubjectTypeInEntry < ActiveRecord::Migration
  def self.up
    Entry.find_all_by_subject_type("Registration").each do |entry|
      entry.update_attribute(:subject_type, "Docket")
    end
  end

  def self.down
    Entry.find_all_by_subject_type("Docket").each do |entry|
      entry.update_attribute(:subject_type, "Registration")
    end
  end
end
