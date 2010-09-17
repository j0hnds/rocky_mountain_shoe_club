class ConvertTable

  def initialize(pgconn, conversion_data)
    @pgconn = pgconn
    @conversion_data = conversion_data
  end

  def convert_data
    puts "Converting #{get_description}..."
    count = process_records
    puts "Converted #{count} records."
  end

  private

  def process_records
    # Process the SQL provided by the derived class.
    res = @pgconn.exec(conversion_sql)

    records = res.collect { | row | convert_record(row) }

    res.clear

    records.size
  end

  def get_description
    self.class.name.tableize.split(/_/).slice(1..-1).join(' ')
  end

end
