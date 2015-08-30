require 'doorkeeper'

Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :doorkeeper, <application_id>, <application_secret>
  provider :doorkeeper, ENV["WEB_CLIENT_ID"], ENV["WEB_CLIENT_SECRET"]
end