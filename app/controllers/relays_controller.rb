class RelaysController < ApplicationController
  load_and_authorize_resource

  # GET /relays
  # GET /relays.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @relays }
    end
  end

  # GET /relays/1
  # GET /relays/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @relay }
    end
  end

  # GET /relays/new
  # GET /relays/new.xml
  def new
    @relay.invitation = Invitation.find(params[:invitation_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @relay }
    end
  end

  # GET /relays/1/edit
  def edit
  end

  # POST /relays
  # POST /relays.xml
  def create
    respond_to do |format|
      if @relay.save
        format.html { redirect_to(@relay.invitation, :notice => 'Relay was successfully created.') }
        format.xml  { render :xml => @relay, :status => :created, :location => @relay }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @relay.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /relays/1
  # PUT /relays/1.xml
  def update
    respond_to do |format|
      if @relay.update_attributes(params[:relay])
        format.html { redirect_to(@relay.invitation, :notice => 'Relay was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @relay.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /relays/1
  # DELETE /relays/1.xml
  def destroy
    @relay.destroy

    respond_to do |format|
      format.html { redirect_to @relay.invitation, :notice => 'Relay was successfully destroyed.' }
      format.xml  { head :ok }
    end
  end
end
