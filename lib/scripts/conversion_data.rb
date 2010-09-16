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

end

