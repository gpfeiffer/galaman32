class InvitationsController < ApplicationController
  load_and_authorize_resource

  # GET /invitations
  # GET /invitations.xml

  ##  FIXME: load and authorize @club instead of @invitation
  def index
    @club = Club.find(params[:club_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invitations }
    end
  end

  # GET /invitations/1
  # GET /invitations/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invitation }
      format.tex 
    end
  end

  # GET /invitations/new
  # GET /invitations/new.xml
  def new
    @invitation[:competition_id] = params[:competition_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invitation }
    end
  end

  # GET /invitations/1/edit
  def edit
  end

  # POST /invitations
  # POST /invitations.xml
  def create
    respond_to do |format|
      if @invitation.save
        format.html { redirect_to(@invitation.competition, :notice => 'Invitation was successfully created.') }
        format.xml  { render :xml => @invitation, :status => :created, :location => @invitation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invitations/1
  # PUT /invitations/1.xml
  def update
    if params[:invitation]
      swimmer_ids = params[:invitation][:swimmer_ids].map(&:to_i)
    else
      swimmer_ids = []
    end
    swimmer_ids = @invitation.swimmer_ids - swimmer_ids
    @invitation.registrations.each do |registration|
      if swimmer_ids.include? registration.swimmer_id
        registration.destroy
      end
    end

    respond_to do |format|
      if @invitation.update_attributes(params[:invitation])
        format.html { redirect_to(@invitation, :notice => 'Invitation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.xml
  def destroy
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to(@invitation.competition, :notice => 'Invitation was successfully deleted.') }
      format.xml  { head :ok }
    end
  end
end
