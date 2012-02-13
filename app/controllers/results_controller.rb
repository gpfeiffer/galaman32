class ResultsController < ApplicationController
  # GET /results
  # GET /results.xml
  def index
    if params[:event_id]
      @event = Event.find(params[:event_id])
    elsif params[:invitation_id]
      @invitation = Invitation.find(params[:invitation_id])
      @competition = @invitation.competition
    elsif params[:competition_id]
      @competition = Competition.find(params[:competition_id])
    else
      @results = Result.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @results }
      format.text { 
        render :file => 'results/index.text.erb'
      }
      format.tex {
        code = render_to_string
        dir = File.join(Rails.root, 'tmp', 'latex')
        tex = File.join(dir, 'results.tex')
        File.open(tex, 'w') { |io| io.write(code) }
        system("pdflatex -interaction=batchmode -output-directory #{dir} #{tex}")
        pdf = File.join(dir, 'results.pdf')
        render :file => pdf, :layout => false, :content_type => "application/pdf"
      }
    end
  end

  # GET /results/1
  # GET /results/1.xml
  def show
    @result = Result.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @result }
    end
  end

  # GET /results/new
  # GET /results/new.xml
  def new
    @result = Result.new
    @result[:entry_id] = params[:entry_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @result }
    end
  end

  # GET /results/1/edit
  def edit
    @result = Result.find(params[:id])
  end

  # POST /results
  # POST /results.xml
  def create
    @result = Result.new(params[:result])
    @result[:time] = time_from_msc(params[:result])

    respond_to do |format|
      if @result.save
        format.html { redirect_to(@result.entry.event, :notice => 'Result was successfully created.') }
        format.xml  { render :xml => @result, :status => :created, :location => @result }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /results/1
  # PUT /results/1.xml
  def update
    @result = Result.find(params[:id])
    @result[:time] = time_from_msc(params[:result])

    respond_to do |format|
      if @result.update_attributes(params[:result])
        format.html { redirect_to(@result.entry.event, :notice => 'Result was successfully updated.') }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @result.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.xml
  def destroy
    @result = Result.find(params[:id])
    @result.destroy

    respond_to do |format|
      format.html { redirect_to @result.entry.event, :notice => 'Result was successfully destroyed.' }
      format.xml  { head :ok }
    end
  end
end
