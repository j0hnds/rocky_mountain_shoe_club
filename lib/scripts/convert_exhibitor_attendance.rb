# To change this template, choose Tools | Templates
# and open the template in the editor.

class ConvertExhibitorAttendance < ConvertTable

  private

  def conversion_sql
    "SELECT * FROM EXHIBITOR_ATTENDANCE"
  end

  def convert_record(row)
    exhibitor_attendance = ExhibitorRegistration.new

    exhibitor_attendance.show_id = @conversion_data.show_mappings[row[0]]
    exhibitor_attendance.exhibitor_id = @conversion_data.exhibitor_mappings[row[1]]
    exhibitor_attendance.room = row[2]

    exhibitor_attendance.save!

    exhibitor_attendance
  end

end
