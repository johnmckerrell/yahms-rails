class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :system
  attr_accessible :system_id, :user_id, :access_level
end
