# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  private

  def error_on_create_messages(model_instance, name=nil)
    obj_name = (name) ? name : model_instance.class.human_name
    error_stickie("<strong>Could not create a new #{obj_name} because of the following problems:</strong>")
    model_instance.errors.each{|key,value| puts "!!! #{value}"; error_stickie("#{value}")}
  end

end
