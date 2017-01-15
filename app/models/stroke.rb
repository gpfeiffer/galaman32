class Stroke < ActiveRecord::Base
  attr_accessible :code, :name, :short

  def to_s
    name
  end
end
