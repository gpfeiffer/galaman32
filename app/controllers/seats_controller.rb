class SeatsController < ApplicationController
  load_and_authorize_resource

  # GET /seats
  # GET /seats.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @seats }
    end
  end

  # GET /seats/1
  # GET /seats/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @seat }
    end
  end

  # GET /seats/new
  # GET /seats/new.xml
  def new
    @seat[:relay_id] = params[:relay_id]
    @seat[:docket_id] = params[:docket_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @seat }
    end
  end

  # GET /seats/1/edit
  def edit
  end

  # POST /seats
  # POST /seats.xml
  def create
    respond_to do |format|
      if @seat.save
        format.html { redirect_to(@seat.relay.invitation, :notice => 'Seat was successfully created.') }
        format.xml  { render :xml => @seat, :status => :created, :location => @seat }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @seat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /seats/1
  # PUT /seats/1.xml
  def update
    respond_to do |format|
      if @seat.update_attributes(params[:seat])
        format.html { redirect_to(@seat.relay.invitation, :notice => 'Seat was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @seat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /seats/1
  # DELETE /seats/1.xml
  def destroy
    @seat.destroy

    respond_to do |format|
      format.html { redirect_to @seat.relay.invitation, :notice => 'Seat was successfully destroyed.' }
      format.xml  { head :ok }
    end
  end
end
