class LanesController < ApplicationController
  def index
    if params[:event_id]
      @event = Event.find(params[:event_id])
      @lanes = @event.lanes
    elsif params[:competition_id]
      @competition = Competition.find(params[:competition_id])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lanes }
      format.tex
    end
  end

end
