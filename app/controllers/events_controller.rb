class EventsController < ApplicationController
  # GET /events
  # GET /events.xml
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
      format.tex {
        render :file => 'events/show.tex.erb',
        :layout => 'layouts/application.tex.erb'
      }
      format.text {
        render :file => 'events/show.text.erb'
      }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    @event[:competition_id] = params[:competition_id]
    @event[:age_min] =  0
    @event[:age_max] =  99

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    @event[:discipline_id] = find_discipline_id(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event.competition, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])
    @event[:discipline_id] = find_discipline_id(params[:event])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event.competition, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to @event.competition }
      format.xml  { head :ok }
    end
  end

  # GET /events/1/list
  def list
    @event = Event.find(params[:id])
    @event.list!

    respond_to do |format|
      format.html { redirect_to results_path(:event_id => @event) }
      format.xml  { head :ok }
    end
  end
end
