# To change this template, choose Tools | Templates
# and open the template in the editor.

class StoresController < ApplicationController
  before_filter :search_term, :only => [ :index, :search ]

  layout "main", :only => [ :index ]

  def index
    @stores = store_list
  end

  # This will be called via Ajax to replace the exhibitor list with the
  # filtered list.
  def search
    @stores = store_list
    render :action => :success
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store])
    if @store.save
      @stores = store_list
      success_stickie("You have successfully created a new store")
      render :action => :success
    else
      error_on_create_messages(@store)
      render :action => :failure
    end
  end

  def edit
    @store = Store.find(params[:id])
  end

  def update
    @store = Store.find(params[:id])

    if @store.update_attributes(params[:store])
      @stores = store_list
      success_stickie("Store successfully updated")
      render :action => :success
    else
      error_on_create_messages(@store)
      render :action => :failure
    end
  end

  def show
    @store = Store.find(params[:id])
  end

  def destroy
    @store = Store.find(params[:id])
    @store.delete
    @stores = store_list
    success_stickie("You have successfully deleted a store")
    render :action => :success
  end

  private

  def store_list
    Store.search_for(@search_term).ordered
  end


end
