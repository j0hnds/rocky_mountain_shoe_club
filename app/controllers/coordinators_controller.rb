class CoordinatorsController < ApplicationController
  
  layout "main", :only => [ :index ]
  
  def index
    @coordinators = Coordinator.all
  end
  
  def new
    @coordinator = Coordinator.new
  end
  
  def create
    @coordinator = Coordinator.new(params[:coordinator])
    if @coordinator.save
      @coordinators = Coordinator.all
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
      @coordinators = Coordinator.all
      success_stickie("Coordinator successfully updated")
      render :action => :success
    else
      error_on_create_messages(@coordinator)
      render :action => :failure
    end
  end

end
