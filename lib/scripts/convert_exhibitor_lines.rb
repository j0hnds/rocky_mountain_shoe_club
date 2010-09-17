# To change this template, choose Tools | Templates
# and open the template in the editor.

class ConvertExhibitorLines < ConvertTable

  private

  def conversion_sql
    "SELECT * FROM ATTENDEE_LINE WHERE ATTENDEE_TYPE = 1"
  end

  def convert_record(row)
    er = @conversion_data.get_exhibitor_registration(row[3], row[2])

    ex_line = ExhibitorLine.new

    ex_line.exhibitor_registration_id = er.id
    ex_line.line = row[4]
    ex_line.priority = row[5]

    ex_line.save!

    ex_line
  end
  
end
