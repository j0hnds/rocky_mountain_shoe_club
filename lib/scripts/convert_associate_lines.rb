class ConvertAssociateLines < ConvertTable

  private

  def conversion_sql
    # Note here that we are only converting the associate lines
    # for the most recent show. This is because the old data model
    # wasn't sufficient to maintain this information over more than
    # one show at a time. Just a bad design.
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

    # The test for a blank id is here because we can't trust the
    # old data model
    ass_line.save! unless ass_line.exhibitor_associate_id.blank?

    ass_line
  end

end
