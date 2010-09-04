class CreateExhibitors < ActiveRecord::Migration
  def self.up
    create_table :exhibitors do |t|
      t.string :first_name, :limit => 40, :null => false
      t.string :last_name, :limit => 40, :null => false
      t.string :address_1, :limit => 40, :null => false
      t.string :address_2, :limit => 40
      t.string :city, :limit => 40, :null => false
      t.string :state, :limit => 2, :null => false
      t.string :postal_code, :limit => 11, :null => false
      t.string :email, :limit => 255
      t.string :phone, :limit => 12
      t.string :fax, :limit => 12
      t.string :cell, :limit => 12

      t.timestamps
    end
  end

  def self.down
    drop_table :exhibitors
  end
end
