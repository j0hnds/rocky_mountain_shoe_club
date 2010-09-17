require 'show_dates'

class ConvertShow < ConvertTable
  include ShowDates

  private

  def conversion_sql
    "SELECT * FROM SHOW ORDER BY START_DATE DESC"
  end

  def convert_record(row)
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

    show.save!

    @conversion_data.add_show_mapping(pg_id, show.id)

    show
  end

end
