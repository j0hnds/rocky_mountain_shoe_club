# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :must_have_current_show

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  private

  def error_on_create_messages(model_instance, name=nil)
    obj_name = (name) ? name : model_instance.class.human_name
    error_stickie("<strong>Could not create a new #{obj_name} because of the following problems:</strong>")
    model_instance.errors.each{|key,value| error_stickie("#{value}")}
  end

  def must_have_current_show
    # Get the current show from the session
    if session[:current_show_id]
      @current_show = Show.find(session[:current_show_id])
    else
      # No current show in session; just use the first one available
      @current_show = Show.ordered.first
    end
  end

  def set_current_show(show)
    @current_show = show
    session[:current_show_id] = @current_show.id
  end

  def search_term
    if params.has_key?(:search)
      @search_term = params[:search]
      session[search_term_key] = @search_term
    else
      @search_term = session[search_term_key]
    end
  end

  def search_term_key
    controller = params[:controller]
    "#{controller}_search_term".to_sym
  end
  
end
