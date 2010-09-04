class ExhibitorsController < ApplicationController

  layout "main", :only => [ :index ]

  def index
    @exhibitors = Exhibitor.all
  end

  def new
    @exhibitor = Exhibitor.new
  end

  def create
    @exhibitor = Exhibitor.new(params[:exhibitor])
    if @exhibitor.save
      @exhibitors = Exhibitor.all
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
      @exhibitors = Exhibitor.all
      success_stickie("You have successfully updated an exhibitor")
      render :action => :success
    else
      error_on_create_messages(@exhibitor)
      render :action => :failure
    end
  end
end
