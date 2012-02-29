class Support < ActiveRecord::Base
  belongs_to :user
  belongs_to :swimmer
end
