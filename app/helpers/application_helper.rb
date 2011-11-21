module ApplicationHelper
  def time_to_msc(time)
    centis = time % 100
    time /= 100
    secs = time % 60
    mins = time / 60
    if mins > 0
      sprintf('%d:%02d.%02d', mins, secs, centis)
    else
      sprintf('%d.%02d', secs, centis)
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
end
