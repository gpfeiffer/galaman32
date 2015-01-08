class DisciplinesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]
  load_and_authorize_resource

  # GET /disciplines
  # GET /disciplines.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @disciplines }
    end
  end

  # GET /disciplines/1
  # GET /disciplines/1.xml
  def show
    @qts_by_qualification = @discipline.qualification_times.group_by(&:qualification)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @discipline }
      format.xml  { render :xml => @discipline }
    end
  end

  # GET /disciplines/new
  # GET /disciplines/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @discipline }
    end
  end

  # GET /disciplines/1/edit
  def edit
  end

  # POST /disciplines
  # POST /disciplines.xml
  def create
    respond_to do |format|
      if @discipline.save
        format.html { redirect_to(@discipline, :notice => 'Discipline was successfully created.') }
        format.xml  { render :xml => @discipline, :status => :created, :location => @discipline }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @discipline.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /disciplines/1
  # PUT /disciplines/1.xml
  def update
    respond_to do |format|
      if @discipline.update_attributes(params[:discipline])
        format.html { redirect_to(@discipline, :notice => 'Discipline was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @discipline.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /disciplines/1
  # DELETE /disciplines/1.xml
  def destroy
    @discipline.destroy

    respond_to do |format|
      format.html { redirect_to(disciplines_url) }
      format.xml  { head :ok }
    end
  end
end
