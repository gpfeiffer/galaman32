class AimsController < ApplicationController
  # GET /aims
  # GET /aims.xml
  def index
    @aims = Aim.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @aims }
    end
  end

  # GET /aims/1
  # GET /aims/1.xml
  def show
    @aim = Aim.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @aim }
    end
  end

  # GET /aims/new
  # GET /aims/new.xml
  def new
    @aim = Aim.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @aim }
    end
  end

  # GET /aims/1/edit
  def edit
    @aim = Aim.find(params[:id])
  end

  # POST /aims
  # POST /aims.xml
  def create
    @aim = Aim.new(params[:aim])

    respond_to do |format|
      if @aim.save
        format.html { redirect_to(@aim, :notice => 'Aim was successfully created.') }
        format.xml  { render :xml => @aim, :status => :created, :location => @aim }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @aim.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /aims/1
  # PUT /aims/1.xml
  def update
    @aim = Aim.find(params[:id])

    respond_to do |format|
      if @aim.update_attributes(params[:aim])
        format.html { redirect_to(@aim, :notice => 'Aim was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @aim.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /aims/1
  # DELETE /aims/1.xml
  def destroy
    @aim = Aim.find(params[:id])
    @aim.destroy

    respond_to do |format|
      format.html { redirect_to(aims_url) }
      format.xml  { head :ok }
    end
  end
end
