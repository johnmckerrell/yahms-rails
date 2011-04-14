class AnalogInput < ActiveRecord::Base
  belongs_to :type, :class_name => 'AnalogInputType', :foreign_key => 'type_id'
  belongs_to :base_station
  has_many :analog_input_logs

  def humanize_value(value)
    case self.type.code
    when "temperature"
      max = 2 ** self.size
      value = value * self.reference
      value /= max
      value = (value - 0.5) * 100
    end
    value
  end
end
