class CreateAssociateLines < ActiveRecord::Migration
  def self.up
    create_table :associate_lines do |t|
      t.integer :exhibitor_associate_id, :null => false
      t.string :line, :limit => 80, :null => false
      t.integer :priority, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :associate_lines
  end
end
