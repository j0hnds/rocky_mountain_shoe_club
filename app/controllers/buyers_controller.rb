class BuyersController < ApplicationController

  before_filter :search_term, :only => [ :index, :search ]

  layout "main", :only => [ :index ]

  def index 
    @buyers = buyer_list
  end

  # This will be called via Ajax to replace the buyer list with the
  # filtered list.
  def search
    @buyers = show_list
    render :action => success
  end

  def new
    @buyer = Buyer.new
    @stores = Store.ordered
  end

  def create
    @buyer = Buyer.new(params[:buyer])
    if @buyer.save
      @buyers = buyer_list
      success_stickie("You have successfully created a new buyer")
      render :action => :success
    else
      error_on_create_messages(@buyer)
      render :action => :failure
    end
  end

  def edit
    @buyer = Buyer.find(params[:id])
    @stores = Store.ordered
  end

  def update
    @buyer = Buyer.find(params[:id])
    
    if @buyer.update_attributes(params[:buyer])
      @buyers = buyer_list
      success_stickie("You have successfully updated a buyer")
      render :action => :success
    else
      error_on_create_messages(@buyer)
      render :action => :failure
    end
  end

  def show
    @buyer = Buyer.find(params[:id])
  end

  def destroy
    @buyer = Buyer.find(params[:id])
    @buyer.delete
    @buyers = buyer_list
    success_stickie("You have successfully deleted a buyer")
    render :action => :success
  end

  private

  def buyer_list
    Buyer.search_for(@search_term).ordered
  end
end
