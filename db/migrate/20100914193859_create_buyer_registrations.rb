class CreateBuyerRegistrations < ActiveRecord::Migration
  def self.up
    create_table :buyer_registrations do |t|
      t.integer :show_id, :null => false
      t.integer :buyer_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :buyer_registrations
  end
end
