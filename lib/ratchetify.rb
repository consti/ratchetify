require "ratchetify/version"

Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/ruby'
  
  desc "Prepare a new uberspace for deployment"
  namespace :prepare do
    
    desc "Tasks to prepare an uberspace for deployment"
    task :default do
    end
    
    desc "Test the login credentials and print some usefull stuff..."
    task :test_credentials do
      run "pwd && whoami"
    end
    
  end
end
