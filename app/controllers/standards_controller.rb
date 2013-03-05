class StandardsController < ApplicationController
  load_and_authorize_resource

  # GET /standards
  # GET /standards.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @standards }
    end
  end

  # GET /standards/1
  # GET /standards/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @standard }
    end
  end

  # GET /standards/new
  # GET /standards/new.xml
  def new
    @standard[:competition_id] = params[:competition_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @standard }
    end
  end

  # GET /standards/1/edit
  def edit
  end

  # POST /standards
  # POST /standards.xml
  def create
    respond_to do |format|
      if @standard.save
        format.html { redirect_to(@standard.competition, :notice => 'Standard was successfully created.') }
        format.xml  { render :xml => @standard, :status => :created, :location => @standard }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @standard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /standards/1
  # PUT /standards/1.xml
  def update
    respond_to do |format|
      if @standard.update_attributes(params[:standard])
        format.html { redirect_to(@standard, :notice => 'Standard was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @standard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /standards/1
  # DELETE /standards/1.xml
  def destroy
    @standard.destroy

    respond_to do |format|
      format.html { redirect_to @standard.competition, :notice => 'Standard was successfully deleted.' }
      format.xml  { head :ok }
    end
  end
end
