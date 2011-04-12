class CreateBaseStations < ActiveRecord::Migration
  def self.up
    create_table :base_stations do |t|
      t.string :name, :null => false
      t.column :xbee_rx_pin, 'TINYINT UNSIGNED'
      t.column :xbee_tx_pin, 'TINYINT UNSIGNED'
      t.string :timezone, :mac_address
      t.references :system, :null => false
      t.timestamps
    end
    add_index :base_stations, [ :system_id ]
    add_index :base_stations, [ :mac_address ], :unique => true
  end

  def self.down
    drop_table :base_stations
  end
end
