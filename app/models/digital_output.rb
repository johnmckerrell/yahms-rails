class DigitalOutput < ActiveRecord::Base
  belongs_to :type, :class_name => 'DigitalOutputType', :foreign_key => 'type_id'
  belongs_to :base_station
  has_many :control_blocks
  belongs_to :transient_control_block, :class_name => 'ControlBlock', :foreign_key => 'transient_control_block_id'
end
