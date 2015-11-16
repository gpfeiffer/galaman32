class Aim < ActiveRecord::Base
  belongs_to :swimmer
  belongs_to :qualification

  delegate :gender, to: :swimmer
  delegate :qualification_times, to: :qualification

  def age
    swimmer.age(date)
  end

  def qtime(discipline)
    qualification_times.where(gender: gender, discipline_id: discipline)
      .find { |qt| qt.age_range.include? age }
  end

  def qtimes
    qualification_times.where(gender: gender)
      .select { |qt| qt.age_range.include? age }
  end
end
