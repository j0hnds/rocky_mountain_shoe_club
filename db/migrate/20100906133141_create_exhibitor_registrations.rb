class CreateExhibitorRegistrations < ActiveRecord::Migration
  def self.up
    create_table :exhibitor_registrations do |t|
      t.integer :exhibitor_id, :null => false
      t.integer :show_id, :null => false
      t.string :room, :limit => 10

      t.timestamps
    end
  end

  def self.down
    drop_table :exhibitor_registrations
  end
end
