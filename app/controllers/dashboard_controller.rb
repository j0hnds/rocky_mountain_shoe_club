# To change this template, choose Tools | Templates
# and open the template in the editor.

class DashboardController < ApplicationController

  layout 'main'

  before_filter :load_shows, :only => [ :show ]

  def show
    
  end

  private

  def load_shows
    @shows = Show.ordered
  end
end
