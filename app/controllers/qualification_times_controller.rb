class QualificationTimesController < ApplicationController
  load_and_authorize_resource

  # GET /qualification_times
  # GET /qualification_times.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @qualification_times }
    end
  end

  # GET /qualification_times/1
  # GET /qualification_times/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @qualification_time }
    end
  end

  # GET /qualification_times/new
  # GET /qualification_times/new.xml
  def new
    @qualification_time.qualification = Qualification.find(params[:qualification_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @qualification_time }
    end
  end

  # GET /qualification_times/1/edit
  def edit
  end

  # POST /qualification_times
  # POST /qualification_times.xml
  def create
    @qualification_time.time = time_from_msc(params[:qualification_time])
    @qualification_time.discipline = find_discipline(params[:qualification_time])

    respond_to do |format|
      if @qualification_time.save
        format.html { redirect_to(@qualification_time.qualification, :notice => 'Qualification time was successfully created.') }
        format.xml  { render :xml => @qualification_time, :status => :created, :location => @qualification_time }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @qualification_time.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /qualification_times/1
  # PUT /qualification_times/1.xml
  def update
    @qualification_time.time = time_from_msc(params[:qualification_time])
    @qualification_time.discipline = find_discipline(params[:qualification_time])

    respond_to do |format|
      if @qualification_time.update_attributes(params[:qualification_time])
        format.html { redirect_to(@qualification_time.qualification, :notice => 'Qualification time was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @qualification_time.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /qualification_times/1
  # DELETE /qualification_times/1.xml
  def destroy
    @qualification_time.destroy

    respond_to do |format|
      format.html { redirect_to(@qualification_time.qualification) }
      format.xml  { head :ok }
    end
  end
end
