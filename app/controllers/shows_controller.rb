class ShowsController < ApplicationController
  layout "main", :only => [ :index ]

  def index
    @shows = Show.all
  end

  def new
    @show = Show.new
    @show.set_default_dates
    @venues = Venue.all
    @coordinators = Coordinator.all
  end

  def create
    @show = Show.new(params[:show])
    if @show.save
      @shows = Show.all
      success_stickie("You have successfully created a new show")
      render :action => :success
    else
      error_on_create_messages(@show)
      render :action => :failure
    end
  end

  def edit
    @show = Show.find(params[:id])
    @venues = Venue.all
    @coordinators = Coordinator.all
  end

  def update
    @show = Show.find(params[:id])

    if @show.update_attributes(params[:show])
      @shows = Show.all
      success_stickie("You have successfully updated a show")
      render :action => :success
    else
      error_on_create_messages(@show)
      render :action => :failure
    end
  end

  def show
    @show = Show.find(params[:id])
  end

  def destroy
    @show = Show.find(params[:id])
    @show.delete
    @shows = Show.all
    success_stickie("You have successfully deleted a show")
    render :action => :success
  end


end
