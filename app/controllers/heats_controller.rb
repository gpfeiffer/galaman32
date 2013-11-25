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
      format.tex 
      # {
      #   code = render_to_string
      #   dir = File.join(Rails.root, 'tmp', 'latex')
      #   tex = File.join(dir, 'heats.tex')
      #   File.open(tex, 'w') { |io| io.write(code) }
      #   system("pdflatex -interaction=batchmode -output-directory #{dir} #{tex}")
      #   pdf = File.join(dir, 'heats.pdf')
      #   render :file => pdf, :layout => false, :content_type => "application/pdf"
      # }
    end
  end

end
