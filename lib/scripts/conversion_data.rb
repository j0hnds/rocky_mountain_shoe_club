class ConversionData

  attr_reader :show_mappings, 
              :exhibitor_mappings, 
              :associate_mappings, 
              :store_mappings, 
              :buyer_mappings
  attr_accessor :latest_show_id, :coordinator_id, :venue_id

  def initialize
    @show_mappings = {}
    @exhibitor_mappings = {}
    @associate_mappings = {}
    @store_mappings = {}
    @buyer_mappings = {}
  end

  def add_show_mapping(pg_id, my_id)
    @latest_show_id ||= pg_id # Set the latest show on the conversion data
    @show_mappings[pg_id] = my_id
  end

  def add_exhibitor_mapping(pg_id, my_id)
    @exhibitor_mappings[pg_id] = my_id
  end

  def add_associate_mapping(pg_id, my_id)
    @associate_mappings[pg_id] = my_id
  end

  def add_store_mapping(pg_id, my_id)
    @store_mappings[pg_id] = my_id
  end

  def add_buyer_mapping(pg_id, my_id)
    @buyer_mappings[pg_id] = my_id
  end

  def get_exhibitor_registration(pg_show_id, pg_exhibitor_id)
    show_id = @show_mappings[pg_show_id]
    exhibitor_id = @exhibitor_mappings[pg_exhibitor_id]
    ExhibitorRegistration.find_by_show_id_and_exhibitor_id(show_id, exhibitor_id)
  end

  EMAIL_CORRECTIONS = {
    'sam @ kaufmans.com' => 'sam@kaufmans.com',
    'edana@skechers' => "edana@skechers.com",
    'cconrardyeaerosoles.com' => "cconrardye@aerosoles.com",
    'todd.home@consolidated shoe.com' => "todd.home@consolidated_shoe.com",
    'wendy.collins@consolidated shoe.com' => "wendy.collins@consolidated_shoe.com"
  }

  def clean_email(obj)
    if obj.respond_to?(:email)
      email = obj.email
      obj.email = EMAIL_CORRECTIONS[email] if EMAIL_CORRECTIONS.has_key?(email)
    end
  end

end

