class ConvertStore < ConvertTable

  private

  def conversion_sql
    <<EOF
SELECT
	C.CHAIN_ID,
	C.NAME,
	S.STORE_ID,
	S.ADDRESS_1,
	S.ADDRESS_2,
	S.CITY,
	S.STATE,
	S.POSTAL_CODE,
	S.PHONE,
	S.FAX
FROM
	CHAIN C,
	STORE S
WHERE
	S.CHAIN_ID = C.CHAIN_ID
EOF
  end

  def convert_record(row)
    store = Store.new

    store.name = row[1]
    store.address_1 = row[3]
    store.address_2 = row[4]
    store.city = row[5]
    store.state = row[6]
    store.postal_code = row[7]
    store.phone = row[8]
    store.fax = row[9]

    store.save!

    @conversion_data.add_store_mapping(row[2], store.id)

    store
  end

end
