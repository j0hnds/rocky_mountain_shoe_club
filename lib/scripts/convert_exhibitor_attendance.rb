# To change this template, choose Tools | Templates
# and open the template in the editor.

class ConvertExhibitorAttendance < ConvertTable
  def convert
    # Query the PG DB for the set of exhibitor attendance data
    res = @pgconn.exec "SELECT * FROM EXHIBITOR_ATTENDANCE"

    exhibitor_attendance = res.collect do | row |
      load_exhibitor_attendance row
    end

    res.clear

    exhibitor_attendance.size
  end

  private

  def load_exhibitor_attendance(row)
    exhibitor_attendance = ExhibitorRegistration.new

    exhibitor_attendance.show_id = @conversion_data.show_mappings[row[0]]
    exhibitor_attendance.exhibitor_id = @conversion_data.exhibitor_mappings[row[1]]
    exhibitor_attendance.room = row[2]

    # Try to save the room assignment
    exhibitor_attendance.save!

    exhibitor_attendance
  end

end
