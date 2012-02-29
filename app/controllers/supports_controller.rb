class SupportsController < ApplicationController
  # GET /supports
  # GET /supports.xml
  def index
    @supports = Support.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @supports }
    end
  end

  # GET /supports/1
  # GET /supports/1.xml
  def show
    @support = Support.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @support }
    end
  end

  # GET /supports/new
  # GET /supports/new.xml
  def new
    @support = Support.new
    @support[:user_id] = params[:user_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @support }
    end
  end

  # GET /supports/1/edit
  def edit
    @support = Support.find(params[:id])
  end

  # POST /supports
  # POST /supports.xml
  def create
    @support = Support.new(params[:support])

    respond_to do |format|
      if @support.save
        format.html { redirect_to(@support.user, :notice => 'Support was successfully created.') }
        format.xml  { render :xml => @support, :status => :created, :location => @support }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @support.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /supports/1
  # PUT /supports/1.xml
  def update
    @support = Support.find(params[:id])

    respond_to do |format|
      if @support.update_attributes(params[:support])
        format.html { redirect_to(@support.user, :notice => 'Support was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @support.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /supports/1
  # DELETE /supports/1.xml
  def destroy
    @support = Support.find(params[:id])
    @support.destroy

    respond_to do |format|
      format.html { redirect_to(supports_url) }
      format.xml  { head :ok }
    end
  end
end
