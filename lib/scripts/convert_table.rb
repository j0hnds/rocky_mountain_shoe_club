class ConvertTable

  def initialize(pgconn, conversion_data)
    @pgconn = pgconn
    @conversion_data = conversion_data
  end

  def convert_data
    puts "Converting #{get_description}..."
    count = convert
    puts "Converted #{count} records."
  end

  private

  def get_description
    self.class.name.tableize.split(/_/).slice(1..-1).join(' ')
  end

end
