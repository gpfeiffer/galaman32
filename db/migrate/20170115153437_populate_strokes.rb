class PopulateStrokes < ActiveRecord::Migration
  def up
    [
      %w{ Freestyle Free },
      %w{ Backstroke Back },
      %w{ Breaststroke Breast },
      %w{ Butterfly Fly },
      %w{ Medley IM }
    ].to_enum.with_index(1).each do |stroke, i|
      Stroke.create(name: stroke[0], short: stroke[1], code: i)
    end

  end

  def down
  end
end
