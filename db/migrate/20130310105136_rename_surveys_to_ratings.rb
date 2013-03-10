class RenameSurveysToRatings < ActiveRecord::Migration
  def self.up
    rename_table :surveys, :ratings
  end

  def self.down
    rename_table :ratings, :surveys
  end
end
