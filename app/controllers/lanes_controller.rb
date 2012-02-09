class LanesController < ApplicationController
  def index
    if params[:event_id]
      @event = Event.find(params[:event_id])
      @lanes = @event.lanes
    elsif params[:competition_id]
      @competition = Competition.find(params[:competition_id])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.tex
      format.xml  { render :xml => @lanes }
      format.tex {
        code = render_to_string
        dir = File.join(Rails.root, 'tmp', 'latex')
        tex = File.join(dir, 'lanes.tex')
        File.open(tex, 'w') { |io| io.write(code) }
        system("pdflatex -interaction=batchmode -output-directory #{dir} #{tex}")
        pdf = File.join(dir, 'lanes.pdf')
        render :file => pdf, :layout => false, :content_type => "application/pdf"
      }
    end
  end

  def show
  end

end
