require "ratchetify/version"

Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/ruby'
  
  # host and domain for the new app
  set :domain, nil
  set :host, nil
  
  # random port used for the reverse proxy
  set :daemon_port, rand(61000-32768+1)+32768  # random port
  
  # internal variables, should not be changed in the cap file
  set :home, "~"
  set :app_dir, "#{home}/apps"
  set :conf_dir, "#{home}/aconf"
  set :ruby_version, "2.0.0"
  
  desc "Prepare a new uberspace for deployment"
  namespace :setup do
    
    desc "Tasks to prepare an uberspace for deployment"
    task :environment do
      
      unless file_exists? '.ratchet'
      
        puts "Initializing uberspace '#{user}'"
        
        # save the current .bashrc
        run "cp .bashrc bashrc.bak"
        
        # create the necessary folders
        create_dir app_dir unless dir_exists? app_dir
        create_dir conf_dir unless dir_exists? conf_dir
          
        # enable ruby
        ruby
        # activate the daemontools
        run "uberspace-setup-svscan"
        
        # done
        run "touch .ratchet"
      end  
    end # task :environment
    
    desc "removes all changes"
    task :clean do
      run "mv bashrc.bak .bashrc"
      run "rm -rf .gem .gemrc .ratchet"
      # keep ~/apps and ~/aconf for now ...
    end # task :clean
    
  end
end
