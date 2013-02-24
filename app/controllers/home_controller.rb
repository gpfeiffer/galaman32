class HomeController < ApplicationController
  skip_before_filter :authorize

  def index

    # what time is it
    @time = Time.zone.now

    # whose birthday is it
    @birthdays = Swimmer.select { |swimmer| swimmer.birthday.day == @time.day and swimmer.birthday.month == @time.month }

    respond_to do |format|
      format.html # index.html.erb
      format.js  {
        user_session[:edit] = (params[:edit] == "true") 
      }
    end
  end

end
