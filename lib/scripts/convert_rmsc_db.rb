#!/usr/bin/env /home/djs/Projects/rocky_mountain_shoe_club/script/runner
#
require 'postgres'

Host = 'localhost'
Port = 5432
DB_name = 'RMSC'
User = 'dms'
Password = 'j0rdan32'

class PostgresConnection

  def connection
    @connection ||= PGconn.connect(Host, Port, '', '', DB_name, User, Password)
  end

  def exec(sql)
    connection.exec sql
  end

  def close
    @connection.close if @connection
    @connection = nil
  end

end

class ConversionData

  attr_reader :show_mappings, :exhibitor_mappings, :associate_mappings, :store_mappings, :buyer_mappings
  attr_accessor :latest_show_id, :coordinator_id, :venue_id

  def initialize
    @show_mappings = {}
    @exhibitor_mappings = {}
    @associate_mappings = {}
    @store_mappings = {}
    @buyer_mappings = {}
  end

  def add_show_mapping(pg_id, my_id)
    @latest_show_id ||= pg_id # Set the latest show on the conversion data
    @show_mappings[pg_id] = my_id
  end

  def add_exhibitor_mapping(pg_id, my_id)
    @exhibitor_mappings[pg_id] = my_id
  end

  def add_associate_mapping(pg_id, my_id)
    @associate_mappings[pg_id] = my_id
  end

  def add_store_mapping(pg_id, my_id)
    @store_mappings[pg_id] = my_id
  end

  def add_buyer_mapping(pg_id, my_id)
    @buyer_mappings[pg_id] = my_id
  end

end

def clear_mysql_database(v1)
  puts "Clearing the database"
  AssociateLine.delete_all
  AssociateRoom.delete_all
  Associate.delete_all
  BuyerAttendance.delete_all
  Buyer.delete_all
  ExhibitorAttendance.delete_all
  ExhibitorLine.delete_all
  ExhibitorRoom.delete_all
  Exhibitor.delete_all
  Store.delete_all
  Show.delete_all
  Coordinator.delete_all
  Venue.delete_all
  puts "Done clearing the database"
end

def load_show(conversion, row)
  show = Show.new

  if !conversion.coordinator_id
    coordinator = Coordinator.new
    venue = Venue.new
  end
  
  pg_id = row[0]
  show.description = row[1]
  show.start_date = row[2]
  show.end_date = row[3]
  # show.next_show = row[13]
  if !conversion.coordinator_id
    coordinator.first_name, coordinator.last_name = row[9].split(/ /)
    coordinator.phone = row[14]
    coordinator.email = row[15]
    venue.name = row[4]
    venue.phone = row[10]
    venue.fax = row[11]
    venue.reservation = row[12]
    venue.address1 = row[16]
    venue.city = row[17]
    venue.state = row[18]
    venue.postal_code = row[19]

    coordinator.save!
    venue.save!
    conversion.coordinator_id = coordinator.id
    conversion.venue_id = venue.id

    show.venue = venue
    show.coordinator = coordinator
  else
    show.coordinator_id = conversion.coordinator_id
    show.venue_id = conversion.venue_id
  end
  
  # Try to save the show
  show.save!

  # Add the mapping to the conversion
  conversion.add_show_mapping(pg_id, show.id)
  
  show
end

def load_exhibitor(conversion, row)
  exhibitor = Exhibitor.new

  pg_id = row[0]
  exhibitor.first_name = row[1]
  exhibitor.address_1 = row[2]
  exhibitor.address_2 = row[3]
  exhibitor.city = row[4]
  exhibitor.state = row[5]
  exhibitor.postal_code = row[6]
  exhibitor.phone = row[7]
  exhibitor.fax = row[8]
  exhibitor.cell = row[9]
  exhibitor.email = row[10]
  #
  # The following takes care of the bad data that exists in the PG DB
  #
  exhibitor.email = "edana@skechers.com" if exhibitor.email == 'edana@skechers'
  exhibitor.email = "cconrardye@aerosoles.com" if exhibitor.email == 'cconrardyeaerosoles.com'
  exhibitor.email = "todd.home@consolidated_shoe.com" if exhibitor.email == 'todd.home@consolidated shoe.com'
  exhibitor.email = "wendy.collins@consolidated_shoe.com" if exhibitor.email == 'wendy.collins@consolidated shoe.com'
  #
  # End of data cleanup section
  #
  exhibitor.last_name = row[11]

  # Try to save the exhibitor
  exhibitor.save!

  # Add the mapping to the conversion
  conversion.add_exhibitor_mapping(pg_id, exhibitor.id)

  exhibitor
end

def load_exhibitor_line(conversion, row)
  ex_line = ExhibitorLine.new

  ex_line.show_id = conversion.show_mappings[row[3]]
  ex_line.exhibitor_id = conversion.exhibitor_mappings[row[2]]
  ex_line.line = row[4]
  ex_line.priority = row[5]

  # Try to save the exhibitor line
  ex_line.save!

  ex_line
end

def load_exhibitor_attendance(conversion, row)
  exhibitor_attendance = ExhibitorAttendance.new
#  room_assignment = RoomAssignment.new

  exhibitor_attendance.show_id = conversion.show_mappings[row[0]]
  exhibitor_attendance.exhibitor_id = conversion.exhibitor_mappings[row[1]]
#  room_assignment.show_id = conversion.show_mappings[row[0]]
#  room_assignment.exhibitor_id = conversion.exhibitor_mappings[row[1]]

  exhibitor_room = ExhibitorRoom.new
  exhibitor_room.exhibitor_attendance
  exhibitor_room.room = row[2]
#  room_assignment.room = row[2]

  # Try to save the room assignment
  exhibitor_attendance.save!
  exhibitor_room.save!
#  room_assignment.save!

  exhibitor_attendance
#  room_assignment
end

def load_associate(conversion, row)
  ex_ass = ExhibitorAssociate.new

  ex_ass.exhibitor_id = conversion.exhibitor_mappings[row[3]]
  ex_ass.show_id = conversion.show_mappings[row[0]]
  ex_ass.first_name = row[4]
  ex_ass.last_name = row[5]
  ex_ass.room = row[2]

  ex_ass.save!

  conversion.add_associate_mapping(row[1], ex_ass.id)

  ex_ass
end

def load_associate_line(conversion, row)
  ass_line = AssociateLine.new

  ass_line.exhibitor_associate_id = conversion.associate_mappings[row[2]]
  ass_line.line = row[4]
  ass_line.priority = row[5]

  ass_line.save! unless ass_line.exhibitor_associate_id.blank?

  ass_line
end

def load_store(conversion, row)
  store = Store.new

  store.name = row[1]
  store.address_1 = row[3]
  store.address_2 = row[4]
  store.city = row[5]
  store.state = row[6]
  store.postal_code = row[7]
  store.phone = row[8]
  store.fax = row[9]

  store.save!

  conversion.add_store_mapping(row[2], store.id)

  store
end

def load_buyer(conversion, row)
  buyer = Buyer.new

  buyer.store_id = conversion.store_mappings[row[1]]
  buyer.first_name = row[2]
  buyer.last_name = row[3]
  buyer.email = row[4]
  buyer.cell = row[5]

  # Clean up invalid data
  #
  buyer.email = 'sam@kaufmans.com' if buyer.email == 'sam @ kaufmans.com'
  #
  # End of invalid data cleanup.

  buyer.save!

  conversion.add_buyer_mapping(row[0], buyer.id)

  buyer
end

def load_buyer_attendance(conversion, row)
  ba = BuyerAttendance.new

  ba.show_id = conversion.show_mappings[row[0]]
  ba.buyer_id = conversion.buyer_mappings[row[1]]

  ba.save!

  ba
end

def load_shows(conversion, conn)
  puts "Loading the shows..."

  # Query the PG DB for the set of shows
  res = conn.exec "SELECT * FROM SHOW ORDER BY START_DATE DESC"

  shows = res.collect do | row |
    load_show conversion, row
  end

  res.clear

  puts "#{shows.size} shows loaded."
end

def load_exhibitors(conversion, conn)
  puts "Loading the exhibitors"

  # Query the PG DB for the set of exhibitors
  res = conn.exec "SELECT * FROM EXHIBITOR"

  exhibitors = res.collect do | row |
    load_exhibitor conversion, row
  end

  res.clear

  puts "#{exhibitors.size} exhibitors loaded."
end

def load_exhibitor_lines(conversion, conn)
  puts "Loading the exhibitor lines"

  # Query the PG DB for the set of exhibitor lines
  res = conn.exec "SELECT * FROM ATTENDEE_LINE WHERE ATTENDEE_TYPE = 1"

  exhibitor_lines = res.collect do | row |
    load_exhibitor_line conversion, row
  end

  res.clear

  puts "#{exhibitor_lines.size} exhibitor lines"
end

def load_exhibitor_attendance_records(conversion, conn)
  puts "Loading the exhibitor attendance"

  # Query the PG DB for the set of exhibitor attendance data
  res = conn.exec "SELECT * FROM EXHIBITOR_ATTENDANCE"

  exhibitor_attendance = res.collect do | row |
    load_exhibitor_attendance conversion, row
  end

  res.clear

  puts "#{exhibitor_attendance.size} exhibitor attendance records"
end

def load_exhibitor_associates(conversion, conn)
  puts "Loading the exhibitor associates"

  # Query the PG DB for the set of associates for exhibitors that have
  # associates attending the latest show
  sql = <<EOF
SELECT
	AA.SHOW_ID,
	AA.ASSOCIATE_ID AS AA_ASSOCIATE_ID,
	AA.ROOM_ASSIGNMENT,
	A.EXHIBITOR_ID,
	A.FIRST_NAME,
	A.LAST_NAME
FROM
	ASSOCIATE_ATTENDANCE AA,
	ASSOCIATE A
WHERE
	AA.SHOW_ID = #{conversion.latest_show_id}
	AND A.ASSOCIATE_ID = AA.ASSOCIATE_ID
EOF
  res = conn.exec sql

  associates = res.collect do | row |
    load_associate conversion, row
  end

  res.clear

  puts "#{associates.size} associate records"
end

def load_associate_lines(conversion, conn)
  puts "Loading the associate lines"

  # Query the PG DB for the set of lines for the associates that have been
  # loaded.
  sql = <<EOF
SELECT
	*
FROM
	ATTENDEE_LINE
WHERE
	ATTENDEE_TYPE = 2
	AND SHOW_ID = #{conversion.latest_show_id}
EOF
  res = conn.exec sql

  lines = res.collect do | row |
    load_associate_line conversion, row
  end

  res.clear

  puts "#{lines.size} associate lines loaded"
end

def load_stores(conversion, conn)
  puts "Loading the stores"

  # Query the PG DB for the set of stores
  sql = <<EOF
SELECT
	C.CHAIN_ID,
	C.NAME,
	S.STORE_ID,
	S.ADDRESS_1,
	S.ADDRESS_2,
	S.CITY,
	S.STATE,
	S.POSTAL_CODE,
	S.PHONE,
	S.FAX
FROM
	CHAIN C,
	STORE S
WHERE
	S.CHAIN_ID = C.CHAIN_ID
EOF

  res = conn.exec sql

  stores = res.collect do | row |
    load_store conversion, row
  end

  res.clear

  puts "#{stores.size} stores loaded"
end

def load_buyers(conversion, conn)
  puts "Loading the buyers"

  sql = "SELECT * FROM BUYER"

  res = conn.exec sql

  buyers = res.collect do | row |
    load_buyer conversion, row
  end

  res.clear

  puts "#{buyers.size} buyers loaded"
end

def load_buyer_attendances(conversion, conn)
  puts "Loading the buyer attendance"

  sql = "SELECT * FROM BUYER_ATTENDANCE"

  res = conn.exec sql

  bas = res.collect do | row |
    load_buyer_attendance conversion, row
  end

  res.clear

  puts "#{bas.size} buyer attendances loaded"
end

# Create the conversion collector
conversion = ConversionData.new

# Get a connection...
pgconn = PostgresConnection.new

# Clear out the mysql database
clear_mysql_database('param')

# Bring in all the shows from the Postgres db
load_shows conversion, pgconn

# Bring in all the exhibitors from the Postgres db
load_exhibitors conversion, pgconn

# Load all the exhibitor attendance information
load_exhibitor_attendance_records conversion, pgconn

# Load all the exhibitor associates
load_exhibitor_associates conversion, pgconn

# Load all the stores from the Postgres db
load_stores conversion, pgconn

# Load all the buyers
load_buyers conversion, pgconn

# Load the buyer attendance
load_buyer_attendances conversion, pgconn

# Load all the exhibitor line information
load_exhibitor_lines conversion, pgconn

# Load all the associate lines
load_associate_lines conversion, pgconn

# Close the connection
pgconn.close
