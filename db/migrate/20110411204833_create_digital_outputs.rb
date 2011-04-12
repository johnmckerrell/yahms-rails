class CreateDigitalOutputs < ActiveRecord::Migration
  def self.up
    create_table :digital_outputs do |t|
      t.string :address, :name, :null => false
      t.datetime :deactivated_at
      t.references :base_station, :type, :null => false
      t.timestamps
    end
    add_index :digital_outputs, [ :base_station_id, :deactivated_at, :type_id ]
  end

  def self.down
    drop_table :digital_outputs
  end
end
