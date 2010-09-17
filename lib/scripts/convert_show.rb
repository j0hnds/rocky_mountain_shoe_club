require 'show_dates'

class ConvertShow < ConvertTable
  include ShowDates

  def convert
    # Query the PG DB for the set of shows
    res = @pgconn.exec "SELECT * FROM SHOW ORDER BY START_DATE DESC"

    shows = res.collect do | row |
      load_show row
    end

    res.clear

    shows.size
  end

  private

  def load_show(row)
    show = Show.new

    unless @conversion_data.coordinator_id
      coordinator = Coordinator.new
      venue = Venue.new
    end

    pg_id = row[0]
    show.description = row[1]
    show.start_date = row[2]
    show.end_date = row[3]
    show.next_start_date = next_show_date(show.end_date)
    show.next_end_date = show.next_start_date + 1.day
    if !@conversion_data.coordinator_id
      coordinator.first_name, coordinator.last_name = row[9].split(/ /)
      coordinator.phone = row[14]
      coordinator.email = row[15]
      venue.name = row[4]
      venue.phone = row[10]
      venue.fax = row[11]
      venue.reservation = row[12]
      venue.address_1 = row[16]
      venue.city = row[17]
      venue.state = row[18]
      venue.postal_code = row[19]

      coordinator.save!
      venue.save!
      @conversion_data.coordinator_id = coordinator.id
      @conversion_data.venue_id = venue.id

      show.venue = venue
      show.coordinator = coordinator
    else
      show.coordinator_id = @conversion_data.coordinator_id
      show.venue_id = @conversion_data.venue_id
    end

    # Try to save the show
    show.save!

    # Add the mapping to the conversion
    @conversion_data.add_show_mapping(pg_id, show.id)

    show
  end


end
