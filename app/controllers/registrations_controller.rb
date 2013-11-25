class RegistrationsController < ApplicationController
  load_and_authorize_resource

  # GET /registrations
  # GET /registrations.xml
  ##  FIXME: load andauthorize @invitation instead of @registration
  def index
    @invitation = Invitation.find(params[:invitation_id])
    @club = @invitation.club
    @competition = @invitation.competition

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @registrations }
      format.text 
    end
  end

  # GET /registrations/1
  # GET /registrations/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @registration }
    end
  end

  # GET /registrations/new
  # GET /registrations/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @registration }
    end
  end

  # GET /registrations/1/edit
  def edit
  end

  # POST /registrations
  # POST /registrations.xml
  def create
    respond_to do |format|
      if @registration.save
        format.html { redirect_to(@registration, :notice => 'Registration was successfully created.') }
        format.xml  { render :xml => @registration, :status => :created, :location => @registration }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @registration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /registrations/1
  # PUT /registrations/1.xml
  def update
    respond_to do |format|
      if @registration.update_attributes(params[:registration])
        format.html { redirect_to(@registration, :notice => 'Registration was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @registration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.xml
  def destroy
    @registration.destroy

    respond_to do |format|
      format.html { redirect_to(registrations_url) }
      format.xml  { head :ok }
    end
  end
end
