class QualificationTime < ActiveRecord::Base
  belongs_to :qualification
  belongs_to :discipline

  attr_writer :mode, :course, :stroke, :distance
  delegate :distance, :course, :stroke, :mode, :is_relay?, :to => :discipline, :allow_nil => :true

  validates :age_min, :age_max, :presence => true, 
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  validates :qualification_id, :discipline_id, :time, :gender, :presence => true

  attr_accessor :mins, :secs, :cens

  validate :age_max_must_not_be_less_than_age_min

  def age_max_must_not_be_less_than_age_min
    if age_max < age_min
      errors.add(:age_max, "must not be less than Age min")
    end
  end

  def cens
    time % 100 if time
  end

  def secs
    (time / 100) % 60 if time
  end

  def mins
    time / 6000 if time
  end

  def age_range
    age_min..age_max
  end

  def to_s
    if mins > 0
      sprintf('%d:%02d.%02d', mins, secs, cens)
    else
      sprintf('%d.%02d', secs, cens)
    end
  end

  def distance_course
    "#{distance}m #{course}"
  end

  # convert into FINA points
  def fina_points
    qualification = Qualification.find_by_name("FINA Base")
    qt = QualificationTime.find_by_qualification_id_and_discipline_id(qualification.id, discipline.id)
    qt ? ((10 * qt.time / time.to_f)**3).to_i : nil
  end
end
