class CoordinatorsController < ApplicationController
  
  layout "main"
  
  def index
    @coordinators = Coordinator.all
  end
  
  def new
    @coordinator = Coordinator.new
  end
  
  def create
    @coordinator = Coordinator.new(params[:coordinator])
    if @coordinator.save
      flash[:notice] = "Successfully saved"
      redirect_to coordinators_path
    else
      render :action => 'new'      
    end
  end
  
  def edit
    @coordinator = Coordinator.find(params[:id])
  end
  
  def update
    @coordinator = Coordinator.find(params[:id])
    
    if @coordinator.update_attributes(params[:coordinator])
      flash[:notice] = "Coordinator successfully updated"
      redirect_to coordinators_path
    else
      render :action => "edit"
    end
  end
end
