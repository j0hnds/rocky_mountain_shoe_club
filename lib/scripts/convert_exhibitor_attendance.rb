# To change this template, choose Tools | Templates
# and open the template in the editor.

class ConvertExhibitorAttendance < ConvertTable
  def convert
    puts "Loading the exhibitor attendance"

    # Query the PG DB for the set of exhibitor attendance data
    res = @pgconn.exec "SELECT * FROM EXHIBITOR_ATTENDANCE"

    exhibitor_attendance = res.collect do | row |
      load_exhibitor_attendance row
    end

    res.clear

    puts "#{exhibitor_attendance.size} exhibitor attendance records"
  end

  private

  def load_exhibitor_attendance(row)
    exhibitor_attendance = ExhibitorRegistration.new
  #  room_assignment = RoomAssignment.new

    exhibitor_attendance.show_id = @conversion_data.show_mappings[row[0]]
    exhibitor_attendance.exhibitor_id = @conversion_data.exhibitor_mappings[row[1]]
  #  room_assignment.show_id = conversion.show_mappings[row[0]]
  #  room_assignment.exhibitor_id = conversion.exhibitor_mappings[row[1]]

  #  exhibitor_room = ExhibitorRoom.new
  #  exhibitor_room.exhibitor_attendance
  #  exhibitor_room.room = row[2]
  #  room_assignment.room = row[2]
    exhibitor_attendance.room = row[2]

    # Try to save the room assignment
    exhibitor_attendance.save!
  #  exhibitor_room.save!
  #  room_assignment.save!

    exhibitor_attendance
  #  room_assignment
  end

end
