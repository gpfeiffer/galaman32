module ApplicationHelper

  def time_to_msc(time)
    return "-" + time_to_msc(-time) if time < 0
    time, cens = time.divmod 100
    mins, secs = time.divmod 60
    if mins > 0
      sprintf('%d:%02d.%02d', mins, secs, cens)
    else
      sprintf('%d.%02d', secs, cens)
    end
  end

  # how to convert a range of ages into words
  def ages_to_words(ages)
    if ages.count == 1
      "#{ages.first} years"
    elsif ages.first == 0
      if ages.last == 99
        'all ages'
      else
        "#{ages.last} years and under"
      end
    else
      if ages.last == 99
        "#{ages.first} years and over"
      else
        "#{ages.first} - #{ages.last} years"
      end
    end
  end

  # how to convert a range of ages into a short string
  def ages_to_s(ages)
    if ages.count == 1
      "#{ages.first}"
    elsif ages.first == 0
      if ages.last == 99
        'all ages'
      else
        "#{ages.last} & u"
      end
    else
      if ages.last == 99
        "#{ages.first} & o"
      else
        "#{ages.first}-#{ages.last}"
      end
    end
  end

  # how to convert a range of ages into a short tex string
  def ages_to_tex(ages)
    if ages.count == 1
      "#{ages.first}"
    elsif ages.first == 0
      if ages.last == 99
        'all ages'
      else
        "#{ages.last} \\& u"
      end
    else
      if ages.last == 99
        "#{ages.first} \\& o"
      else
        "#{ages.first}--#{ages.last}"
      end
    end
  end

  def distance_course(code)
    "#{1 + code / 100}m #{(100 - code % 100).chr}C"
  end

  def short_stroke_name(stroke)
    { 
      'Freestyle' => 'Free', 
      'Backstroke' => 'Back', 
      'Breaststroke' => 'Breast', 
      'Butterfly' => 'Fly', 
      'Ind Medley' => 'Medley' 
    }[stroke]
  end

  def girls_or_boys(gender)
    { 
      'f' => "Girls", 
      'm' => "Boys" 
    }[gender]
  end
end

