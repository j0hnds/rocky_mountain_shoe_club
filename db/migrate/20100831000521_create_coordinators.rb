class CreateCoordinators < ActiveRecord::Migration
  def self.up
    create_table :coordinators do |t|
      t.string :first_name, :limit => 40, :null => false
      t.string :last_name, :limit => 40, :null => false
      t.string :email, :limit => 40, :null => false
      t.string :phone, :limit => 12, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :coordinators
  end
end
