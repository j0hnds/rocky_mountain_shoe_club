class ConvertBuyerAttendance < ConvertTable

  def convert
    puts "Loading the buyer attendance"

    sql = "SELECT * FROM BUYER_ATTENDANCE"

    res = @pgconn.exec sql

    bas = res.collect do | row |
      load_buyer_attendance row
    end

    res.clear

    puts "#{bas.size} buyer attendances loaded"
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
