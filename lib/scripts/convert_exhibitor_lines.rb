# To change this template, choose Tools | Templates
# and open the template in the editor.

class ConvertExhibitorLines < ConvertTable
  def convert
    # Query the PG DB for the set of exhibitor lines
    res = @pgconn.exec "SELECT * FROM ATTENDEE_LINE WHERE ATTENDEE_TYPE = 1"

    exhibitor_lines = res.collect do | row |
      load_exhibitor_line row
    end

    res.clear

    exhibitor_lines.size
  end

  private

  def load_exhibitor_line(row)
    er = @conversion_data.get_exhibitor_registration(row[3], row[2])

    ex_line = ExhibitorLine.new

    ex_line.exhibitor_registration_id = er.id
    ex_line.line = row[4]
    ex_line.priority = row[5]

    # Try to save the exhibitor line
    ex_line.save!

    ex_line
  end
  
end
