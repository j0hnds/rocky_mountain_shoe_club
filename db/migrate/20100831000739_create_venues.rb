class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      t.string :name, :limit => 40, :null => false
      t.string :address_1, :limit => 40, :null => false
      t.string :address_2, :limit => 40
      t.string :city, :limit => 40, :null => false
      t.string :state, :limit => 2, :null => false
      t.string :postal_code, :limit => 11, :null => false
      t.string :phone, :limit => 12, :null => false
      t.string :fax, :limit => 12
      t.string :reservation, :limit => 12

      t.timestamps
    end
  end

  def self.down
    drop_table :venues
  end
end
