class CoordinatorsController < ApplicationController
  
  before_filter :search_term, :only => [ :index, :search ]

  layout "main", :only => [ :index ]
  
  def index
    @coordinators = coordinator_list
  end
  
  # This will be called via Ajax to replace the exhibitor list with the
  # filtered list.
  def search
    @coordinators = coordinator_list
    render :action => :success
  end

  def new
    @coordinator = Coordinator.new
  end
  
  def create
    @coordinator = Coordinator.new(params[:coordinator])
    if @coordinator.save
      @coordinators = coordinator_list
      success_stickie("You have successfully created a new coordinator")
      render :action => :success
    else
      error_on_create_messages(@coordinator)
      render :action => :failure
    end
  end
  
  def edit
    @coordinator = Coordinator.find(params[:id])
  end
  
  def update
    @coordinator = Coordinator.find(params[:id])
    
    if @coordinator.update_attributes(params[:coordinator])
      @coordinators = coordinator_list
      success_stickie("Coordinator successfully updated")
      render :action => :success
    else
      error_on_create_messages(@coordinator)
      render :action => :failure
    end
  end

  def show
    @coordinator = Coordinator.find(params[:id])
  end

  def destroy
    @coordinator = Coordinator.find(params[:id])
    @coordinator.delete
    @coordinators = coordinator_list
    success_stickie("You have successfully deleted a coordinator")
    render :action => :success
  end

  private

  def coordinator_list
    Coordinator.search_for(@search_term).ordered
  end

end
