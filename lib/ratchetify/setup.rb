
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/ruby'
  
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
        run "uberspace-setup-svscan" unless dir_exists? 'service'
        
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
    
  end # namespace
end
