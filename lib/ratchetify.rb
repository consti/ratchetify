require "ratchetify/version"

Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/ruby'
  
  set :home, "~"
  set :daemon_port, rand(61000-32768+1)+32768  # random ephemeral port
  set :app_dir, "#{home}/apps"
  set :conf_dir, "#{home}/confa"
  
  desc "Prepare a new uberspace for deployment"
  namespace :prepare do
    
    desc "Tasks to prepare an uberspace for deployment"
    task :default do
      if not file_exists? '.ratchet'

        puts "Initializing uberspace '#{user}'"
        
        create_dir(app_dir) unless dir_exists? (app_dir)
        create_dir conf_dir unless dir_exists? conf_dir
          
        #run "touch .ratchet"
      else
        puts "Uberspace has already been initialized."
      end
    end
    
    desc "Test the login credentials"
    task :test_credentials do
      run "pwd && whoami"
    end
    
  end
end
