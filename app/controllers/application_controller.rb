class ApplicationController < ActionController::Base
  before_filter :authorize
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
    keys = ['gender', 'distance', 'course', 'stroke']
    subs = opts.reject { |k, v| not keys.include?(k) }
    discipline = Discipline.where(subs).first || Discipline.create(subs)
    return discipline.id
  end

  protected

  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_url, :notice => "Please log in"
    end
  end

end
