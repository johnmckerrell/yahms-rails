class DigitalOutput < ActiveRecord::Base
  belongs_to :type, :class_name => 'AnalogInputType', :foreign_key => 'type_id'
  belongs_to :base_station
  has_many :control_blocks
end
