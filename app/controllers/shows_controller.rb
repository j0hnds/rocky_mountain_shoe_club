class ShowsController < ApplicationController

  before_filter :search_term, :only => [ :index, :search ]
  skip_before_filter :must_have_current_show, :only => [ :change ]

  layout "main", :only => [ :index ]

  def index
    @shows = show_list
  end

  # This will be called via Ajax to replace the exhibitor list with the
  # filtered list.
  def search
    @shows = show_list
    render :action => :success
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
      @shows = show_list
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
      @shows = show_list
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
    @shows = show_list
    success_stickie("You have successfully deleted a show")
    render :action => :success
  end

  def change
    show = Show.find(params[:current_show])
    set_current_show(show)

    redirect_to '/'
  end

  private

  def show_list
    Show.search_for(@search_term).ordered
  end

end
