class QualificationsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]
  load_and_authorize_resource

  # GET /qualifications
  # GET /qualifications.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @qualifications }
    end
  end

  # GET /qualifications/1
  # GET /qualifications/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @qualification }
      format.tex
    end
  end

  # GET /qualifications/new
  # GET /qualifications/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @qualification }
    end
  end

  # GET /qualifications/1/edit
  def edit
  end

  # POST /qualifications
  # POST /qualifications.xml
  def create
    respond_to do |format|
      if @qualification.save
        format.html { redirect_to(@qualification, :notice => 'Qualification was successfully created.') }
        format.xml  { render :xml => @qualification, :status => :created, :location => @qualification }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @qualification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /qualifications/1
  # PUT /qualifications/1.xml
  def update
    respond_to do |format|
      if @qualification.update_attributes(params[:qualification])
        format.html { redirect_to(@qualification, :notice => 'Qualification was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @qualification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /qualifications/1
  # DELETE /qualifications/1.xml
  def destroy
    @qualification.destroy

    respond_to do |format|
      format.html { redirect_to(qualifications_url) }
      format.xml  { head :ok }
    end
  end
end
