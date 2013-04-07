class CreateControlBlocks < ActiveRecord::Migration
  def self.up
    create_table :control_blocks do |t|
      t.column :minute, 'tinyint unsigned'
      t.column :hour, 'tinyint unsigned'
      t.column :day, 'tinyint unsigned'
      t.column :month, 'tinyint unsigned'
      t.column :weekday, 'tinyint unsigned'
      t.column :len, 'smallint unsigned', :null => false
      t.column :state, :boolean, :null => false, :default => 1
      t.datetime :deactivated_at
      t.references :base_station, :digital_output, :null => false
      t.timestamps
    end
    add_index :control_blocks, [ :base_station_id, :deactivated_at ]
  end

  def self.down
    drop_table :control_blocks
  end
end
