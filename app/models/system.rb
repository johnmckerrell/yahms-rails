class System < ActiveRecord::Base
  has_many :subscriptions
  has_many :base_stations
end
