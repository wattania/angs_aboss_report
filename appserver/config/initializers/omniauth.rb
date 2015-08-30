=begin
require 'doorkeeper'

Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :doorkeeper, <application_id>, <application_secret>
  provider :doorkeeper, "e10a898a4c2e63b2a4b3c2b7ad029fff835a22f65fe8c2f6aea24631132c22b8", "59b3c7ff07cdf26d75b8a5528e98c301794ad112f906fdda3fc3193a0e51c82b"
end
=end