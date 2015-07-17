class CopyFieldsFromEntry < ActiveRecord::Migration
  def up
    Result.all.each do |result|
      entry = result.entry
      result.heat = entry.heat
      result.lane = entry.lane
      result.stage = entry.stage
      result.save
    end
  end

  def down
    Result.all.each do |result|
      entry = result.entry
      entry.heat = result.heat
      entry.lane = result.lane
      entry.stage = result.stage
      entry.save
    end
  end
end
