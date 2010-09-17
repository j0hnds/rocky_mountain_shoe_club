class ConvertBuyer < ConvertTable

  private

  def conversion_sql
    "SELECT * FROM BUYER"
  end

  def convert_record(row)
    buyer = Buyer.new

    buyer.store_id = @conversion_data.store_mappings[row[1]]
    buyer.first_name = row[2]
    buyer.last_name = row[3]
    buyer.email = row[4]
    buyer.cell = row[5]

    # Clean up invalid data
    #
    @conversion_data.clean_email(buyer)
    #
    # End of invalid data cleanup.

    buyer.save!

    @conversion_data.add_buyer_mapping(row[0], buyer.id)

    buyer
  end


end
