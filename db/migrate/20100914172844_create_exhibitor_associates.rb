class CreateExhibitorAssociates < ActiveRecord::Migration
  def self.up
    create_table :exhibitor_associates do |t|
      t.integer :exhibitor_registration_id, :null => false
      t.string :first_name, :limit => 40, :null => false
      t.string :last_name, :limit => 40, :null => false
      t.string :room, :limit => 10

      t.timestamps
    end
  end

  def self.down
    drop_table :exhibitor_associates
  end
end
