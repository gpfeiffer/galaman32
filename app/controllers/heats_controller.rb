class HeatsController < ApplicationController
  load_and_authorize_resource

  # GET /heats
  # GET /heats.xml
  ##  FIXME: load and authorize
  def index
    if params[:event_id]
      @event = Event.find(params[:event_id])
      @heats = @event.heats
    elsif params[:competition_id]
      @competition = Competition.find(params[:competition_id])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @heats }
      format.text { 
        render :file => 'heats/index.text.erb'
      }
      format.tex {
        code = render_to_string
        dir = File.join(Rails.root, 'tmp', 'latex')
        tex = File.join(dir, 'heats.tex')
        File.open(tex, 'w') { |io| io.write(code) }
        system("pdflatex -interaction=batchmode -output-directory #{dir} #{tex}")
        pdf = File.join(dir, 'heats.pdf')
        render :file => pdf, :layout => false, :content_type => "application/pdf"
      }
    end
  end

  # GET /heats/1
  # GET /heats/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @heat }
    end
  end

  # GET /heats/new
  # GET /heats/new.xml
  def new
    @event = Event.find(params[:event_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @heat }
    end
  end

  # GET /heats/1/edit
  def edit
  end

  # POST /heats
  # POST /heats.xml
  ##  FIXME: load and authorize
  def create
    @event = Event.find(params[:event_id])

    @event.heats.each { |heat| heat.destroy }
    @event.to_heats(params[:width].to_i).each_with_index do |list, index|
      heat = Heat.new
      heat.pos = index + 1
      @event.heats << heat
      heat.entries = list
    end

    respond_to do |format|
      format.html { redirect_to(heats_path(:event_id => @event.id), :notice => 'Heats were successfully created.') }
      format.xml  { render :xml => @heat, :status => :created, :location => @heat }
      end
  end

  # PUT /heats/1
  # PUT /heats/1.xml
  def update
    respond_to do |format|
      if @heat.update_attributes(params[:heat])
        format.html { redirect_to(@heat, :notice => 'Heat was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @heat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /heats/1
  # DELETE /heats/1.xml
  def destroy
    @heat.destroy

    respond_to do |format|
      format.html { redirect_to(heats_url) }
      format.xml  { head :ok }
    end
  end
end
