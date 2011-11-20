class HeatsController < ApplicationController
  # GET /heats
  # GET /heats.xml
  def index
    @event = Event.find(params[:event_id])
    @heats = @event.heats
    @lanes = @event.entries.map { |x| x.lane }.sort.uniq

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @heats }
    end
  end

  # GET /heats/1
  # GET /heats/1.xml
  def show
    @heat = Heat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @heat }
    end
  end

  # GET /heats/new
  # GET /heats/new.xml
  def new
    @event = Event.find(params[:event_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @heat }
    end
  end

  # GET /heats/1/edit
  def edit
    @heat = Heat.find(params[:id])
  end

  # POST /heats
  # POST /heats.xml
  def create
    @event = Event.find(params[:event_id])
    @event.heats.each { |heat| heat.destroy }
    pos = 0
    @event.to_heats.each do |list|
      pos += 1
      heat = Heat.new
      heat.pos = pos
      @event.heats << heat
      heat.entries = list
    end

    respond_to do |format|
      format.html { redirect_to(heats_path(:event_id => @event.id), :notice => 'Heats were successfully created.') }
      format.xml  { render :xml => @heat, :status => :created, :location => @heat }
      end
  end

  # PUT /heats/1
  # PUT /heats/1.xml
  def update
    @heat = Heat.find(params[:id])

    respond_to do |format|
      if @heat.update_attributes(params[:heat])
        format.html { redirect_to(@heat, :notice => 'Heat was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @heat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /heats/1
  # DELETE /heats/1.xml
  def destroy
    @heat = Heat.find(params[:id])
    @heat.destroy

    respond_to do |format|
      format.html { redirect_to(heats_url) }
      format.xml  { head :ok }
    end
  end
end
