class CreateSurveys < ActiveRecord::Migration
  def self.up
    create_table :surveys do |t|
      t.integer :coach_ability
      t.integer :athletes_knowledge
      t.integer :technical_competency
      t.integer :physical_conditioning
      t.integer :strength
      t.integer :power
      t.integer :agility
      t.integer :balance
      t.integer :team_work
      t.integer :sustainable_power
      t.integer :confidence
      t.integer :time_management
      t.integer :communication
      t.integer :motivation
      t.integer :health_managment
      t.integer :nutrition
      t.integer :recovery
      t.integer :flexibility
      t.integer :local_muscle_endurance
      t.integer :cardiovascular_endurance
      t.integer :strength_endurance
      t.integer :coordination
      t.integer :psychological_skills

      t.timestamps
    end
  end

  def self.down
    drop_table :surveys
  end
end
