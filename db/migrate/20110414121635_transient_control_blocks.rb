class TransientControlBlocks < ActiveRecord::Migration
  def self.up
    add_column :digital_outputs, :transient_control_block_id, :integer
    add_column :control_blocks, :year, 'smallint unsigned'
  end

  def self.down
    remove_column :digital_outputs, :transient_control_block_id
    remove_column :control_blocks, :year
  end
end
