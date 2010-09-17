#!/usr/bin/env /home/djs/Projects/rocky_mountain_shoe_club/script/runner
#
require RAILS_ROOT + '/lib/scripts/postgres_conn'
require RAILS_ROOT + '/lib/scripts/conversion_data'
require RAILS_ROOT + '/lib/scripts/convert_table'
require RAILS_ROOT + '/lib/scripts/convert_show'
require RAILS_ROOT + '/lib/scripts/convert_exhibitor'
require RAILS_ROOT + '/lib/scripts/convert_exhibitor_attendance'
require RAILS_ROOT + '/lib/scripts/convert_exhibitor_associate'
require RAILS_ROOT + '/lib/scripts/convert_exhibitor_lines'
require RAILS_ROOT + '/lib/scripts/convert_store'
require RAILS_ROOT + '/lib/scripts/convert_buyer'
require RAILS_ROOT + '/lib/scripts/convert_buyer_attendance'
require RAILS_ROOT + '/lib/scripts/convert_associate_lines'

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
cea = ConvertExhibitorAssociate.new(pgconn, conversion)
cea.convert
# load_exhibitor_associates conversion, pgconn

# Load all the stores from the Postgres db
cs = ConvertStore.new(pgconn, conversion)
cs.convert
# load_stores conversion, pgconn

# Load all the buyers
cb = ConvertBuyer.new(pgconn, conversion)
cb.convert
# load_buyers conversion, pgconn

# Load the buyer attendance
cba = ConvertBuyerAttendance.new(pgconn, conversion)
cba.convert
# load_buyer_attendances conversion, pgconn

# Load all the exhibitor line information
cel = ConvertExhibitorLines.new(pgconn, conversion)
cel.convert
#load_exhibitor_lines conversion, pgconn

# Load all the associate lines
cal = ConvertAssociateLines.new(pgconn, conversion)
cal.convert
# load_associate_lines conversion, pgconn

# Close the connection
pgconn.close
