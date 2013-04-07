class CreateDigitalOutputTypes < ActiveRecord::Migration
  def self.up
    create_table :digital_output_types do |t|
      t.string :code, :title, :null => false
      t.timestamps
    end
    add_index :digital_output_types, [ :code ]
  end

  def self.down
    drop_table :digital_output_types
  end
end
