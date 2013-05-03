class EntriesController < ApplicationController
  load_and_authorize_resource

  # GET /entries
  # GET /entries.xml
  ##  FIXME: load and authorize @entries
  def index
    @entries = Club.find(params[:club_id]).entries

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entries }
    end
  end

  # GET /entries/1
  # GET /entries/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entry }
    end
  end

  # GET /entries/new
  # GET /entries/new.xml
  def new
    @entry[:event_id] = params[:event_id]
    @entry[:registration_id] = params[:registration_id]
    @entry[:relay_id] = params[:relay_id]

    if params[:registration_id]
      # find personal best a use as default seed time
      swimmer = Registration.find(params[:registration_id]).swimmer
      discipline = Event.find(params[:event_id]).discipline
      @best = swimmer.personal_best(discipline)
      @cobest = swimmer.personal_best(discipline.opposite)
      if @best
        @entry[:time] = @best.time
      end
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @entry }
    end
  end

  # GET /entries/1/edit
  def edit
  end

  # POST /entries
  # POST /entries.xml
  def create
    @entry[:time] = time_from_msc(params[:entry])

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry.invitation, :notice => 'Entry was successfully created.' }
        format.xml  { render :xml => @entry, :status => :created, :location => @entry }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.xml
  def update
    @entry[:time] = time_from_msc(params[:entry])

    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        format.html { redirect_to @entry.invitation, :notice => 'Entry was successfully updated.' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.xml
  def destroy
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to @entry.invitation, :notice => 'Entry was successfully destroyed.' }
      format.xml  { head :ok }
    end
  end
end
