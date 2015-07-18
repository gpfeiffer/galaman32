class ResultsController < ApplicationController
  load_and_authorize_resource

  # GET /results
  # GET /results.xml
  ##  FIXME: load and authorize @results
  def index
    if params[:event_id]
      @event = Event.find(params[:event_id])
    elsif params[:invitation_id]
      @invitation = Invitation.find(params[:invitation_id])
    elsif params[:competition_id]
      @competition = Competition.find(params[:competition_id])
    elsif params[:club_id]
      @club = Club.find(params[:club_id])
      @results = @club.results
    else
      @results = Result.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @results }
      format.text 
      format.tex 
    end
  end

  # GET /results/1
  # GET /results/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @result }
    end
  end

  # GET /results/new
  # GET /results/new.xml
  def new
    @result[:entry_id] = params[:entry_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @result }
    end
  end

  # GET /results/1/edit
  def edit
  end

  # POST /results
  # POST /results.xml
  def create
    if params[:result][:comment].blank?
      @result[:time] = time_from_msc(params[:result])
    else
      @result[:time] = 0
      @result[:place] = ""
    end

    respond_to do |format|
      if @result.save
        format.html { redirect_to(@result.entry.event, :notice => 'Result was successfully created.') }
        format.xml  { render :xml => @result, :status => :created, :location => @result }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /results/1
  # PUT /results/1.xml
  def update
    if params[:result][:comment].blank?
      @result[:time] = time_from_msc(params[:result])
    else
      @result[:time] = 0
      params[:result][:place] = ""
    end

    respond_to do |format|
      if @result.update_attributes(params[:result])
        format.html { redirect_to(@result.entry.event, :notice => 'Result was successfully updated.') }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @result.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.xml
  def destroy
    @result.destroy

    respond_to do |format|
      format.html { redirect_to @result.entry.event, :notice => 'Result was successfully destroyed.' }
      format.xml  { head :ok }
    end
  end

end
