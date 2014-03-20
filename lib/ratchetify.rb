require "ratchetify/version"

Capistrano::Configuration.instance.load do
  
  desc "Prepare a new uberspace for deployment"
  namespace :prepare do
  end
end

#module Ratchetify
#end
