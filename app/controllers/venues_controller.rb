class VenuesController < ApplicationController
  layout "main", :only => [ :index ]

  def index
    @venues = Venue.all
  end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(params[:venue])
    if @venue.save
      @venues = Venue.all
      success_stickie("Successfully created venue")
      render :action => :success
    else
      error_on_create_messages(@venue)
      render :action => :failure
    end
  end

  def edit
    @venue = Venue.find(params[:id])
  end

  def update
    @venue = Venue.find(params[:id])

    if @venue.update_attributes(params[:venue])
      @venues = Venue.all
      success_stickie("Successfully updated venue")
      render :action => :success
    else
      error_on_create_messages(@venue)
      render :action => :failure
    end
  end

  def show
    @venue = Venue.find(params[:id])
  end

  def destroy
    @venue = Venue.find(params[:id])
    @venue.delete
    @venues = Venue.all
    success_stickie("You have successfully deleted a venue")
    render :action => :success
  end


end
