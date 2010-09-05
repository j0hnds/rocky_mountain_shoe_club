class ExhibitorsController < ApplicationController

  before_filter :search_term, :only => [ :index, :search ]
  
  layout "main", :only => [ :index ]

  def index
    @exhibitors = exhibitor_list
  end

  # This will be called via Ajax to replace the exhibitor list with the
  # filtered list.
  def search
    @exhibitors = exhibitor_list
    render :action => :success
  end

  def new
    @exhibitor = Exhibitor.new
  end

  def create
    @exhibitor = Exhibitor.new(params[:exhibitor])
    if @exhibitor.save
      @exhibitors = exhibitor_list
      success_stickie("You have successfully created an exhibitor")
      render :action => :success
    else
      error_on_create_messages(@exhibitor)
      render :action => :failure
    end
  end

  def edit
    @exhibitor = Exhibitor.find(params[:id])
  end

  def update
    @exhibitor = Exhibitor.find(params[:id])

    if @exhibitor.update_attributes(params[:exhibitor])
      @exhibitors = exhibitor_list
      success_stickie("You have successfully updated an exhibitor")
      render :action => :success
    else
      error_on_create_messages(@exhibitor)
      render :action => :failure
    end
  end
  
  def show
    @exhibitor = Exhibitor.find(params[:id])
  end

  def destroy
    @exhibitor = Exhibitor.find(params[:id])
    @exhibitor.delete
    @exhibitors = exhibitor_list
    success_stickie("You have successfully deleted an exhibitor")
    render :action => :success
  end

  private

  def exhibitor_list
    Exhibitor.search_for(@search_term).ordered
  end

end
