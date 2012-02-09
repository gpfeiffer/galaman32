class InvitationsController < ApplicationController
  # GET /invitations
  # GET /invitations.xml
  def index
    @invitations = Invitation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invitations }
    end
  end

  # GET /invitations/1
  # GET /invitations/1.xml
  def show
    @invitation = Invitation.find(params[:id])
    @club = @invitation.club
    @competition = @invitation.competition

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invitation }
      format.tex {
        code = render_to_string
        dir = File.join(Rails.root, 'tmp', 'latex')
        tex = File.join(dir, 'invitation.tex')
        File.open(tex, 'w') { |io| io.write(code) }
        system("pdflatex -interaction=batchmode -output-directory #{dir} #{tex}")
        pdf = File.join(dir, 'invitation.pdf')
        render :file => pdf, :layout => false, :content_type => "application/pdf"
      }
    end
  end

  # GET /invitations/new
  # GET /invitations/new.xml
  def new
    @invitation = Invitation.new
    @invitation[:competition_id] = params[:competition_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invitation }
    end
  end

  # GET /invitations/1/edit
  def edit
    @invitation = Invitation.find(params[:id])
  end

  # POST /invitations
  # POST /invitations.xml
  def create
    @invitation = Invitation.new(params[:invitation])

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
    @invitation = Invitation.find(params[:id])
    swimmer_ids = params[:invitation][:swimmer_ids].map { |x| x.to_i }
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
    @invitation = Invitation.find(params[:id])
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to(@invitation.competition, :notice => 'Invitation was successfully deleted.') }
      format.xml  { head :ok }
    end
  end
end
