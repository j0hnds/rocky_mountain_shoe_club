class ConvertExhibitorAssociate < ConvertTable

  private

  def conversion_sql
    <<EOF
SELECT
	AA.SHOW_ID,
	AA.ASSOCIATE_ID AS AA_ASSOCIATE_ID,
	AA.ROOM_ASSIGNMENT,
	A.EXHIBITOR_ID,
	A.FIRST_NAME,
	A.LAST_NAME
FROM
	ASSOCIATE_ATTENDANCE AA,
	ASSOCIATE A
WHERE
	AA.SHOW_ID = #{@conversion_data.latest_show_id}
	AND A.ASSOCIATE_ID = AA.ASSOCIATE_ID
EOF
  end

  def convert_record(row)
    er = @conversion_data.get_exhibitor_registration(row[0], row[3])

    ex_ass = ExhibitorAssociate.new

    ex_ass.exhibitor_registration_id = er.id if er
    ex_ass.first_name = row[4]
    ex_ass.last_name = row[5]
    ex_ass.room = row[2]

    ex_ass.save! if er

    @conversion_data.add_associate_mapping(row[1], ex_ass.id)

    ex_ass
  end


end
