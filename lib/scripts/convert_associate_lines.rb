class ConvertAssociateLines < ConvertTable

  private

  def conversion_sql
    <<EOF
SELECT
	*
FROM
	ATTENDEE_LINE
WHERE
	ATTENDEE_TYPE = 2
	AND SHOW_ID = #{@conversion_data.latest_show_id}
EOF
  end

  def convert_record(row)
    ass_line = AssociateLine.new

    ass_line.exhibitor_associate_id = @conversion_data.associate_mappings[row[2]]
    ass_line.line = row[4]
    ass_line.priority = row[5]

    ass_line.save! unless ass_line.exhibitor_associate_id.blank?

    ass_line
  end

end
