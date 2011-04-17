class DigitalOutput < ActiveRecord::Base
  belongs_to :type, :class_name => 'DigitalOutputType', :foreign_key => 'type_id'
  belongs_to :base_station
  has_many :control_blocks
  belongs_to :transient_control_block, :class_name => 'ControlBlock', :foreign_key => 'transient_control_block_id'

  def valid_day_blocks(t)
    control_blocks = self.control_blocks.find(:all, :conditions => { :deactivated_at => nil })
    valid_blocks = []
    control_blocks.each do |cb|
      if cb.day and cb.day != t.day
        next
      end
      if cb.month and cb.month != t.month
        next
      end
      
      if cb.weekday
        if cb.weekday == 8 and ( t.weekday == 1 || t.weekday == 7 )
          # dow is valid - weekend
        elsif cb.weekday == 9 and t.weekday >= 2 and t.weekday <= 6
          # dow is valid - weekday
        elsif cb.weekday and t.weekday != cb.weekday
          # invalid
          next
        end
      end
      valid_blocks << cb
    end
    valid_blocks
  end

  def active_control_blocks
    t = self.base_station.current_time
    control_blocks = valid_day_blocks(t)

    minsSinceMidnight = t.hour*60+t.minute

    pinState = nil
    active_blocks = []
    control_blocks.each do |cb|
      if cb.hour
        if cb.minute
          mins = cb.hour*60+cb.minute
          if mins <= minsSinceMidnight and (mins+cb.len) > minsSinceMidnight
            active_blocks << cb
          end
        elsif cb.hour == t.hour
          active_blocks << cb
        end
      elsif cb.minute
        if cb.minute <= t.minute and (cb.minute+cb.len) > t.minute
          active_blocks << cb
        end
      end
    end
    active_blocks
  end

  def state_for_blocks(blocks)
    state = nil
    blocks.each do |cb|
      state = cb.state
      if state == false
        break
      end
    end
    if state.nil?
      state = false
    end
    state
  end

  def current_state
    state_for_blocks(active_control_blocks)
  end
end
