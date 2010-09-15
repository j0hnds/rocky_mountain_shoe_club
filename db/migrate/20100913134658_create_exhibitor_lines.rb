class CreateExhibitorLines < ActiveRecord::Migration
  def self.up
    create_table :exhibitor_lines do |t|
      t.integer :exhibitor_registration_id, :null => false
      t.string :line, :limit => 80, :null => false
      t.integer :priority, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :exhibitor_lines
  end
end
