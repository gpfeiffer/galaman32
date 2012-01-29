class HomeController < ApplicationController
  skip_before_filter :authorize

  def index

    # what time is it
    @time = Time.zone.now

    # whose birthday is it
    @birthdays = Swimmer.select { |swimmer| swimmer.birthday.day == @time.day and swimmer.birthday.month == @time.month }
  end

end
