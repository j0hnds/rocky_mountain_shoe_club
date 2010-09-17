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

CONVERSIONS = [ ConvertShow,
                ConvertExhibitor,
                ConvertExhibitorAttendance,
                ConvertExhibitorAssociate,
                ConvertStore,
                ConvertBuyer,
                ConvertBuyerAttendance,
                ConvertExhibitorLines,
                ConvertAssociateLines
              ]

# Create the conversion collector
conversion = ConversionData.new

# Get a connection...
pgconn = PostgresConnection.new

# Clear out the mysql database
pgconn.clear_mysql_database

# Run the conversions...
CONVERSIONS.each do | conversion_class |
  conversion = conversion_class.new(pgconn, conversion)
  conversion.convert_data
end

# Close the connection
pgconn.close
