# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rocky_mountain_shoe_club_session',
  :secret      => '42a6069d7dd6442a86daa092d6d5c12045208538d335e4ed9fee7fbe885118794b2a617f83b6726b72401502b36c849ffa9414521c666e7b7c8569e720d849a1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
