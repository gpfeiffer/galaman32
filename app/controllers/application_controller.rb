class ApplicationController < ActionController::Base
  protect_from_forgery

  # how to convert a hash with components mins, secs, centis into time
  def time_from_msc(opts)
    m = opts[:mins].to_i
    s = opts[:secs].to_i
    c = opts[:centis].to_i
    100 * (60 * m + s) + c
  end

  # how to find the discipline, or create a new one
  def find_discipline_id(opts)
    #FIXME: Why do these have to be strings, and not keys:
    #FIXME: find list of keys automatically in discipline model
    keys = ['gender', 'distance', 'course', 'stroke', 'mode']
    subs = opts.reject { |k, v| not keys.include?(k) }
    discipline = Discipline.where(subs).first || Discipline.create(subs)
    return discipline.id
  end

end
