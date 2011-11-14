class SwimmersController < ApplicationController
  # GET /swimmers
  # GET /swimmers.xml
  def index
    @swimmers = Swimmer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @swimmers }
    end
  end

  # GET /swimmers/1
  # GET /swimmers/1.xml
  def show
    @swimmer = Swimmer.find(params[:id])
    @results = @swimmer.results.group_by { |result| result.discipline }
    @rows = @results.keys.map { |x| { :distance => x.distance, :course => x.course } }.sort_by { |x| [x[:distance], -x[:course][0].ord] }.uniq 

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @swimmer }
    end
  end

  # GET /swimmers/new
  # GET /swimmers/new.xml
  def new
    @swimmer = Swimmer.new
    @swimmer[:club_id] = params[:club_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @swimmer }
    end
  end

  # GET /swimmers/1/edit
  def edit
    @swimmer = Swimmer.find(params[:id])
  end

  # POST /swimmers
  # POST /swimmers.xml
  def create
    @swimmer = Swimmer.new(params[:swimmer])

    respond_to do |format|
      if @swimmer.save
        format.html { redirect_to(@swimmer.club, :notice => 'Swimmer was successfully created.') }
        format.xml  { render :xml => @swimmer, :status => :created, :location => @swimmer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @swimmer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /swimmers/1
  # PUT /swimmers/1.xml
  def update
    @swimmer = Swimmer.find(params[:id])

    respond_to do |format|
      if @swimmer.update_attributes(params[:swimmer])
        format.html { redirect_to(@swimmer.club, :notice => 'Swimmer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @swimmer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /swimmers/1
  # DELETE /swimmers/1.xml
  def destroy
    @swimmer = Swimmer.find(params[:id])
    @swimmer.destroy

    respond_to do |format|
      format.html { redirect_to(swimmers_url) }
      format.xml  { head :ok }
    end
  end
end