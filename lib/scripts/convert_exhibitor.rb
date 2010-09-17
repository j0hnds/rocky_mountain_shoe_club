# To change this template, choose Tools | Templates
# and open the template in the editor.

class ConvertExhibitor < ConvertTable

  private

  def conversion_sql
    "SELECT * FROM EXHIBITOR"
  end

  def convert_record(row)
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
    @conversion_data.clean_email(exhibitor)
    #
    # End of data cleanup section
    #
    exhibitor.last_name = row[11]

    # Try to save the exhibitor
    exhibitor.save!

    # Add the mapping to the conversion
    @conversion_data.add_exhibitor_mapping(pg_id, exhibitor.id)

    exhibitor
  end

end
