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
end
