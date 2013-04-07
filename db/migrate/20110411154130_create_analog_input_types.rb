class CreateAnalogInputTypes < ActiveRecord::Migration
  def self.up
    create_table :analog_input_types do |t|
      t.string :code, :title, :null => false
      t.timestamps
    end
    add_index :analog_input_types, [ :code ], :unique => true
  end

  def self.down
    drop_table :analog_input_types
  end
end
