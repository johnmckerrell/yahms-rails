class CreateAnalogInputLogs < ActiveRecord::Migration
  def self.up
    create_table :analog_input_logs, :options => 'ENGINE MyISAM' do |t|
      t.integer :value
      t.references :analog_input
      t.timestamps
    end
    add_index :analog_input_logs, [ :analog_input_id ]
  end

  def self.down
    drop_table :analog_input_logs
  end
end
