class DocketsController < ApplicationController
  load_and_authorize_resource

  # GET /dockets
  # GET /dockets.xml
  ##  FIXME: load andauthorize @invitation instead of @docket
  def index
    @invitation = Invitation.find(params[:invitation_id])
    @club = @invitation.club
    @competition = @invitation.competition

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dockets }
      format.text 
    end
  end

  # GET /dockets/1
  # GET /dockets/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @docket }
    end
  end

  # GET /dockets/new
  # GET /dockets/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @docket }
    end
  end

  # GET /dockets/1/edit
  def edit
  end

  # POST /dockets
  # POST /dockets.xml
  def create
    respond_to do |format|
      if @docket.save
        format.html { redirect_to(@docket, :notice => 'Docket was successfully created.') }
        format.xml  { render :xml => @docket, :status => :created, :location => @docket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @docket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dockets/1
  # PUT /dockets/1.xml
  def update
    respond_to do |format|
      if @docket.update_attributes(params[:docket])
        format.html { redirect_to(@docket, :notice => 'Docket was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @docket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dockets/1
  # DELETE /dockets/1.xml
  def destroy
    @docket.destroy

    respond_to do |format|
      format.html { redirect_to @docket.invitation }
      format.xml  { head :ok }
    end
  end
end
