class System < ActiveRecord::Base
  has_many :subscriptions
  has_many :base_stations

  def self.find_authorized_systems(user_id)
    find(:all,
          :conditions => [ "id IN (SELECT system_id FROM subscriptions WHERE user_id = ?)", user_id ] )
  end

  def self.find_authorized_system(system_id, user_id)
    find(:first,
          :conditions => [ "id IN (SELECT system_id FROM subscriptions WHERE system_id = ? AND user_id = ?)", system_id, user_id ] )
  end
end
