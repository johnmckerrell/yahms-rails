class User < ActiveRecord::Base
  acts_as_authentic
  has_many :subscriptions
  attr_accessible :login, :password, :password_confirmation
end
