class ExhibitorsController < ApplicationController

  layout "main"

  def index
    @exhibitors = Exhibitor.all
  end

  def new
    @exhibitor = Exhibitor.new
  end

  def create
    @exhibitor = Exhibitor.new(params[:exhibitor])
    if @exhibitor.save
      flash[:notice] = "Successfully saved"
      redirect_to exhibitors_path
    else
      render :action => 'new'
    end
  end

  def edit
    @exhibitor = Exhibitor.find(params[:id])
  end

  def update
    @exhibitor = Exhibitor.find(params[:id])

    if @exhibitor.update_attributes(params[:exhibitor])
      flash[:notice] = "Exhibitor successfully updated"
      redirect_to exhibitors_path
    else
      render :action => "edit"
    end
  end
end
