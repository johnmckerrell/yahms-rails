class ControlBlock < ActiveRecord::Base
  belongs_to :base_station
  belongs_to :digital_output
end
