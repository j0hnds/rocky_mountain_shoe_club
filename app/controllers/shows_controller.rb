class ShowsController < ApplicationController
  layout "main"

  def index
    @shows = Show.all
  end

  def new
    @show = Show.new
    @show.set_default_dates
  end

  def create
    @show = Show.new(params[:show])
    if @show.save
      flash[:notice] = "Successfully saved"
      redirect_to shows_path
    else
      render :action => 'new'
    end
  end

  def edit
    @show = Show.find(params[:id])
  end

  def update
    @show = Show.find(params[:id])

    if @show.update_attributes(params[:show])
      flash[:notice] = "Show successfully updated"
      redirect_to shows_path
    else
      render :action => "edit"
    end
  end
end
