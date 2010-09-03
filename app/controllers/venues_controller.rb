class VenuesController < ApplicationController
  layout "main"

  def index
    @venues = Venue.all
  end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(params[:venue])
    if @venue.save
      flash[:notice] = "Successfully saved"
      redirect_to venues_path
    else
      render :action => 'new'
    end
  end

  def edit
    @venue = Venue.find(params[:id])
  end

  def update
    @venue = Venue.find(params[:id])

    if @venue.update_attributes(params[:venue])
      flash[:notice] = "Venue successfully updated"
      redirect_to venues_path
    else
      render :action => "edit"
    end
  end
end
