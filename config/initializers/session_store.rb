# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_redgate_session',
  :secret      => '6582e6dcf5e81a24e016000348a25199653e449c5a65049f8aaeffad4ac7555620a07f425e12a95929a8a37f98f319f24c85c846c17f203e93e8d78f5be50b51'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
