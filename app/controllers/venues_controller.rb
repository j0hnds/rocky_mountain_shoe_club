class VenuesController < ApplicationController

  before_filter :search_term, :only => [ :index, :search ]

  layout "main", :only => [ :index ]

  def index
    @venues = venue_list
  end

  # This will be called via Ajax to replace the exhibitor list with the
  # filtered list.
  def search
    @venues = venue_list
    render :action => :success
  end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(params[:venue])
    if @venue.save
      @venues = venue_list
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
      @venues = venue_list
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
    @venues = venue_list
    success_stickie("You have successfully deleted a venue")
    render :action => :success
  end

  private

  def venue_list
    Venue.search_for(@search_term).ordered
  end

end
