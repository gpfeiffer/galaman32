class UppercaseGenderInSwimmer < ActiveRecord::Migration
  def up
    Swimmer.all.each do |swimmer|
      swimmer.update_attribute(:gender, swimmer.gender.upcase)
    end
  end

  def down
    Swimmer.all.each do |swimmer|
      swimmer.update_attribute(:gender, swimmer.gender.downcase)
    end
  end
end
