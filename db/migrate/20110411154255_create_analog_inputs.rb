class CreateAnalogInputs < ActiveRecord::Migration
  def self.up
    create_table :analog_inputs do |t|
      t.string :name, :address, :null => false
      t.column :size, 'TINYINT UNSIGNED', :null => false
      t.column :reference, :decimal, :precision => 8, :scale => 2, :null => false
      t.references :base_station, :type, :null => false
      t.datetime :deactivated_at
      t.timestamps
    end
    add_index :analog_inputs, [ :base_station_id, :deactivated_at, :type_id ]
  end

  def self.down
    drop_table :analog_inputs
  end
end
