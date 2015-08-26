require 'doorkeeper'

Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :doorkeeper, <application_id>, <application_secret>
  provider :doorkeeper, "afffc43a8c4bc9c365eba86ad18ef65a36594bf17d02a1e279247eb845c0d016", "8108c964bcf493858dd7a5ee4732ce902777d2777a0677cccba2d29166859900"
end