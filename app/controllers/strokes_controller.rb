class StrokesController < ApplicationController
  before_filter :set_stroke, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @strokes = Stroke.all
    respond_with(@strokes)
  end

  def show
    if params[:club_id]
      @club = Club.find(params[:club_id])
      @results = @club.results.select { |x| x.time > 0 && x.stroke == @stroke.name }
    end
    respond_with(@stroke)
  end

  def new
    @stroke = Stroke.new
    respond_with(@stroke)
  end

  def edit
  end

  def create
    @stroke = Stroke.new(params[:stroke])
    @stroke.save
    respond_with(@stroke)
  end

  def update
    @stroke.update_attributes(params[:stroke])
    respond_with(@stroke)
  end

  def destroy
    @stroke.destroy
    respond_with(@stroke)
  end

  private
    def set_stroke
      @stroke = Stroke.find(params[:id])
    end
end
