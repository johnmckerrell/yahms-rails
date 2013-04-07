class AnalogInput < ActiveRecord::Base
  belongs_to :type, :class_name => 'AnalogInputType', :foreign_key => 'type_id'
  belongs_to :base_station
  has_many :analog_input_logs

  def recent_logs( limit )
    AnalogInputLog.find(:all,
      :limit => limit,
      :order => "created_at DESC",
      :conditions => [ "analog_input_id = ?", self.id ] )
  end

  def recent_logs_humanized( limit )
    analog_input_logs = self.recent_logs(limit)

    logs = []
    analog_input_logs.each do |l|
      logs << { :created_at => l.created_at, :value => l.value, :human_value => self.humanize_value(l.value) }
    end
    logs
  end

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
