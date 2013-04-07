# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_yahms_net_session',
  :secret      => 'e36de45a97d6e3e02976957c26e2bf384403b7aa6cc8b88394dddfd1c659a64730cf6951229628c3b2fc9992eb7946befda78fb0b711d994b5d9a3ad5897601b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
