module ExhibitorsHelper

  def exhibitor_in_show(exhibitor, show)
    (exhibitor.shows.include?(show)) ? "Yes" : "No"
  end

  def exhibitor_is_in_show(exhibitor, show)
    exhibitor.shows.include?(show)
  end
end
