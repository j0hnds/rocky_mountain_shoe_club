class ConvertBuyerAttendance < ConvertTable

  def convert
    sql = "SELECT * FROM BUYER_ATTENDANCE"

    res = @pgconn.exec sql

    bas = res.collect do | row |
      load_buyer_attendance row
    end

    res.clear

    bas.size
  end

  private

  def load_buyer_attendance(row)
    ba = BuyerRegistration.new

    ba.show_id = @conversion_data.show_mappings[row[0]]
    ba.buyer_id = @conversion_data.buyer_mappings[row[1]]

    ba.save!

    ba
  end

end
