class CreateBuyers < ActiveRecord::Migration
  def self.up
    create_table :buyers do |t|
      t.integer :store_id, :null => false
      t.string :first_name, :limit => 40, :null => false
      t.string :last_name, :limit => 40, :null => false
      t.string :phone, :limit => 12
      t.string :email, :limit => 255

      t.timestamps
    end
  end

  def self.down
    drop_table :buyers
  end
end
