class AdminController < ApplicationController
  def index
    @total_swimmers = Swimmer.count
    @total_clubs = Club.count
    @total_competitions = Competition.count
  end

end
