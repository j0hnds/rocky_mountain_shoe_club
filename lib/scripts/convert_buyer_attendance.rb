class ConvertBuyerAttendance < ConvertTable

  private

  def conversion_sql
    "SELECT * FROM BUYER_ATTENDANCE"
  end

  def convert_record(row)
    ba = BuyerRegistration.new

    ba.show_id = @conversion_data.show_mappings[row[0]]
    ba.buyer_id = @conversion_data.buyer_mappings[row[1]]

    ba.save!

    ba
  end

end
