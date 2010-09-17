#!/usr/bin/env /home/djs/Projects/rocky_mountain_shoe_club/script/runner
#
require RAILS_ROOT + '/lib/scripts/postgres_conn'
require RAILS_ROOT + '/lib/scripts/conversion_data'
require RAILS_ROOT + '/lib/scripts/convert_table'
require RAILS_ROOT + '/lib/scripts/convert_show'
require RAILS_ROOT + '/lib/scripts/convert_exhibitor'
require RAILS_ROOT + '/lib/scripts/convert_exhibitor_attendance'
require RAILS_ROOT + '/lib/scripts/convert_exhibitor_lines'

#def load_associate(conversion, row)
#  ex_ass = ExhibitorAssociate.new
#
#  ex_ass.exhibitor_id = conversion.exhibitor_mappings[row[3]]
#  ex_ass.show_id = conversion.show_mappings[row[0]]
#  ex_ass.first_name = row[4]
#  ex_ass.last_name = row[5]
#  ex_ass.room = row[2]
#
#  ex_ass.save!
#
#  conversion.add_associate_mapping(row[1], ex_ass.id)
#
#  ex_ass
#end

#def load_associate_line(conversion, row)
#  ass_line = AssociateLine.new
#
#  ass_line.exhibitor_associate_id = conversion.associate_mappings[row[2]]
#  ass_line.line = row[4]
#  ass_line.priority = row[5]
#
#  ass_line.save! unless ass_line.exhibitor_associate_id.blank?
#
#  ass_line
#end

#def load_store(conversion, row)
#  store = Store.new
#
#  store.name = row[1]
#  store.address_1 = row[3]
#  store.address_2 = row[4]
#  store.city = row[5]
#  store.state = row[6]
#  store.postal_code = row[7]
#  store.phone = row[8]
#  store.fax = row[9]
#
#  store.save!
#
#  conversion.add_store_mapping(row[2], store.id)
#
#  store
#end

#def load_buyer(conversion, row)
#  buyer = Buyer.new
#
#  buyer.store_id = conversion.store_mappings[row[1]]
#  buyer.first_name = row[2]
#  buyer.last_name = row[3]
#  buyer.email = row[4]
#  buyer.cell = row[5]
#
#  # Clean up invalid data
#  #
#  buyer.email = 'sam@kaufmans.com' if buyer.email == 'sam @ kaufmans.com'
#  #
#  # End of invalid data cleanup.
#
#  buyer.save!
#
#  conversion.add_buyer_mapping(row[0], buyer.id)
#
#  buyer
#end

#def load_buyer_attendance(conversion, row)
#  ba = BuyerAttendance.new
#
#  ba.show_id = conversion.show_mappings[row[0]]
#  ba.buyer_id = conversion.buyer_mappings[row[1]]
#
#  ba.save!
#
#  ba
#end

#
#

#def load_exhibitor_associates(conversion, conn)
#  puts "Loading the exhibitor associates"
#
#  # Query the PG DB for the set of associates for exhibitors that have
#  # associates attending the latest show
#  sql = <<EOF
#SELECT
#	AA.SHOW_ID,
#	AA.ASSOCIATE_ID AS AA_ASSOCIATE_ID,
#	AA.ROOM_ASSIGNMENT,
#	A.EXHIBITOR_ID,
#	A.FIRST_NAME,
#	A.LAST_NAME
#FROM
#	ASSOCIATE_ATTENDANCE AA,
#	ASSOCIATE A
#WHERE
#	AA.SHOW_ID = #{conversion.latest_show_id}
#	AND A.ASSOCIATE_ID = AA.ASSOCIATE_ID
#EOF
#  res = conn.exec sql
#
#  associates = res.collect do | row |
#    load_associate conversion, row
#  end
#
#  res.clear
#
#  puts "#{associates.size} associate records"
#end

#def load_associate_lines(conversion, conn)
#  puts "Loading the associate lines"
#
#  # Query the PG DB for the set of lines for the associates that have been
#  # loaded.
#  sql = <<EOF
#SELECT
#	*
#FROM
#	ATTENDEE_LINE
#WHERE
#	ATTENDEE_TYPE = 2
#	AND SHOW_ID = #{conversion.latest_show_id}
#EOF
#  res = conn.exec sql
#
#  lines = res.collect do | row |
#    load_associate_line conversion, row
#  end
#
#  res.clear
#
#  puts "#{lines.size} associate lines loaded"
#end

#def load_stores(conversion, conn)
#  puts "Loading the stores"
#
#  # Query the PG DB for the set of stores
#  sql = <<EOF
#SELECT
#	C.CHAIN_ID,
#	C.NAME,
#	S.STORE_ID,
#	S.ADDRESS_1,
#	S.ADDRESS_2,
#	S.CITY,
#	S.STATE,
#	S.POSTAL_CODE,
#	S.PHONE,
#	S.FAX
#FROM
#	CHAIN C,
#	STORE S
#WHERE
#	S.CHAIN_ID = C.CHAIN_ID
#EOF
#
#  res = conn.exec sql
#
#  stores = res.collect do | row |
#    load_store conversion, row
#  end
#
#  res.clear
#
#  puts "#{stores.size} stores loaded"
#end

#def load_buyers(conversion, conn)
#  puts "Loading the buyers"
#
#  sql = "SELECT * FROM BUYER"
#
#  res = conn.exec sql
#
#  buyers = res.collect do | row |
#    load_buyer conversion, row
#  end
#
#  res.clear
#
#  puts "#{buyers.size} buyers loaded"
#end

#def load_buyer_attendances(conversion, conn)
#  puts "Loading the buyer attendance"
#
#  sql = "SELECT * FROM BUYER_ATTENDANCE"
#
#  res = conn.exec sql
#
#  bas = res.collect do | row |
#    load_buyer_attendance conversion, row
#  end
#
#  res.clear
#
#  puts "#{bas.size} buyer attendances loaded"
#end

# Create the conversion collector
conversion = ConversionData.new

# Get a connection...
pgconn = PostgresConnection.new

# Clear out the mysql database
pgconn.clear_mysql_database

# Bring in all the shows from the Postgres db
cs = ConvertShow.new(pgconn, conversion)
cs.convert
# load_shows conversion, pgconn

# Bring in all the exhibitors from the Postgres db
ce = ConvertExhibitor.new(pgconn, conversion)
ce.convert
#load_exhibitors conversion, pgconn

# Load all the exhibitor attendance information
cea = ConvertExhibitorAttendance.new(pgconn, conversion)
cea.convert
#load_exhibitor_attendance_records conversion, pgconn

# Load all the exhibitor associates
# load_exhibitor_associates conversion, pgconn

# Load all the stores from the Postgres db
# load_stores conversion, pgconn

# Load all the buyers
# load_buyers conversion, pgconn

# Load the buyer attendance
# load_buyer_attendances conversion, pgconn

# Load all the exhibitor line information
cel = ConvertExhibitorLines.new(pgconn, conversion)
cel.convert
#load_exhibitor_lines conversion, pgconn

# Load all the associate lines
# load_associate_lines conversion, pgconn

# Close the connection
pgconn.close
