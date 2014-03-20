require "ratchetify/version"

Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/test'
  
  desc "Prepare a new uberspace for deployment"
  namespace :prepare do
    
    desc "Tasks to prepare an uberspace for deployment"
    task :default do
    end
    
  end
end
