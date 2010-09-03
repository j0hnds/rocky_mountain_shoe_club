module ShowsHelper

  def venue_options(venues)
    venues.map { |venue| [ venue.name, venue.id ] }
  end

  def coordinator_options(coordinators)
    coordinators.map { |coordinator| [ "#{coordinator.first_name} #{coordinator.last_name}", coordinator.id ] }
  end
end
