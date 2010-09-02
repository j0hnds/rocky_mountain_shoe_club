class CreateShows < ActiveRecord::Migration
  def self.up
    create_table :shows do |t|
      t.string :description, :limit => 40, :null => false
      t.integer :coordinator_id, :null => false
      t.integer :venue_id, :null => false
      t.date :start_date, :null => false
      t.date :end_date, :null => false
      t.date :next_start_date, :null => false
      t.date :next_end_date, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :shows
  end
end
