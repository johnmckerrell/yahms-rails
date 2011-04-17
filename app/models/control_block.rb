class ControlBlock < ActiveRecord::Base
  belongs_to :base_station
  belongs_to :digital_output

  # Get the next start time for this block
  # the block will have been checked for day already
  def next_start_time(from_time)
    t = from_time
    next_year = t.year
    next_month = t.month
    next_day = t.day
    next_hour = hour
    if next_hour.nil?
      next_hour = t.hour
    end
    if next_hour < t.hour
      return nil
    end
    next_minute = minute
    if next_minute.nil?
      next_minute = 0
    end
    next_time = ArduinoTime.utc(next_year,next_month,next_day,next_hour,next_minute,0)
    if next_hour == t.hour and next_minute < t.minute
      if hour.nil?
        # This is a repeating time that has already occurred
        # this hour so look at the next one
        next_time = ArduinoTime.at(next_time+1.hour)
      else
        # This was a time for this hour but the minute
        # has passed already
        return nil
      end
    end
    next_time
  end

  def current_start_time
    t = base_station.current_time
    current_year = year
    if current_year.nil?
      current_year = t.year
    end
    current_month = month
    if current_month.nil?
      current_month = t.month
    end
    current_day = day
    if current_day.nil?
      current_day = t.day
    end
    current_hour = hour
    if current_hour.nil?
      current_hour = t.hour
    end
    current_minute = minute
    if current_minute.nil?
      current_minute = 0
    end
    ArduinoTime.utc(current_year,current_month,current_day,current_hour,current_minute,0)
  end

  def current_end_time
    start = current_start_time
    current_len = len
    if minute.nil?
      current_len = 60
    end
    ArduinoTime.at(start+(current_len*60))
  end

  def set_start_time(t)
    update_attributes( :minute => t.min,
      :hour => t.hour,
      :day => t.day,
      :month => t.month,
      :year => t.year,
      :weekday => nil )
  end

  def set_start_and_end_time(start_time, end_time)
    set_start_time(start_time)
    self.len = ( end_time - start_time ) / 60
  end

  def to_api
    pin = self.digital_output.address
    pin = pin.slice(1,pin.length-1)
    "C:#{num_or_star(minute)} #{num_or_star(hour)} #{num_or_star(day)} #{num_or_star(month)} #{num_or_star(weekday)} #{len} #{pin}#{state ? '' : ' 0'}"
  end

  private
  def num_or_star(num)
    num.nil? ? "*" : num.to_s
  end
end
