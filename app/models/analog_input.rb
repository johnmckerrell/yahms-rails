class AnalogInput < ActiveRecord::Base
  belongs_to :type, :class_name => 'AnalogInputType', :foreign_key => 'type_id'
  belongs_to :base_station
  has_many :analog_input_logs
end
