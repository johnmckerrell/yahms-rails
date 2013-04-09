class AnalogInputLog < ActiveRecord::Base
  belongs_to :analog_input
  attr_accessible :analog_input_id, :value
end
