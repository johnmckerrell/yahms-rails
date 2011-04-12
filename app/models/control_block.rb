class ControlBlock < ActiveRecord::Base
  belongs_to :base_station
  belongs_to :digital_output

  def to_api
    "C:#{num_or_star(minute)} #{num_or_star(hour)} #{num_or_star(day)} #{num_or_star(month)} #{num_or_star(weekday)} #{len}#{state ? '' : ' 0'}"
  end

  private
  def num_or_star(num)
    num.nil? ? "*" : num.to_s
  end
end
