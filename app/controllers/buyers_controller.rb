class BuyersController < ApplicationController

  before_filter :search_term, :only => [ :index, :search ]

  layout "main", :only => [ :index ]

  def index 
    @buyers = buyer_list
  end

  # This will be called via Ajax to replace the buyer list with the
  # filtered list.
  def search
    @buyers = buyer_list
    render :action => :success
  end

  def new
    @buyer = Buyer.new
    @stores = Store.ordered
  end

  def create
    @buyer = Buyer.new(params[:buyer])
    if @buyer.save
      success_stickie("You have successfully created a new buyer")
      if params[:form_location] == 'store_add'
        @store = @buyer.store
        @buyers = buyer_list(@buyer.store)
        render :action => :store_success
      else
        @buyers = buyer_list
        render :action => :success
      end
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
      success_stickie("You have successfully updated a buyer")
      @buyers = buyer_list
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

  def buyer_list(store=nil)
    (store) ? store.buyers.ordered : Buyer.search_for(@search_term).ordered
  end

end
