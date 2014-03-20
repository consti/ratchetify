require "ratchetify/version"

Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/ruby'
  
  desc "Prepare a new uberspace for deployment"
  namespace :prepare do
    
    desc "Tasks to prepare an uberspace for deployment"
    task :default do
      unless file_exists? '.ratchet'
        puts "Initializing uberspace '#{user}'"
      end
    end
    
    desc "Test the login credentials"
    task :test_credentials do
      run "pwd && whoami"
    end
    
  end
end
