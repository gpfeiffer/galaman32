class HeatsController < ApplicationController
  # GET /heats
  # GET /heats.xml
  ##  FIXME: load and authorize
  def index
    if params[:event_id]
      @event = Event.find(params[:event_id])
      @heats = @event.heats
    elsif params[:competition_id]
      @competition = Competition.find(params[:competition_id])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @heats }
      format.text 
      format.tex 
    end
  end

end
