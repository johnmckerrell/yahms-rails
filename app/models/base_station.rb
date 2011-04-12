class BaseStation < ActiveRecord::Base
  belongs_to :system
  has_many :analog_inputs
  has_many :control_blocks
  has_many :digital_outputs
end
