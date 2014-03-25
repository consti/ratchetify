
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/ruby'
  
  desc "Prepare a new uberspace for deployment"
  namespace :setup do
    
    desc "Prepare an uberspace for deployment"
    task :default do
      environment
    end
    
    desc "Create dirs, configure ruby, activate daemontools, ..."
    task :environment do
      
      unless file_exists? '.ratchet'
      
        puts "Initializing uberspace '#{user}'"
        
        # save the current .bashrc
        run "cp .bashrc bashrc.bak"
        
        # create the necessary folders
        create_dir deploy_root unless dir_exists? deploy_root
        create_dir conf_dir unless dir_exists? conf_dir
        run "ln -s #{deploy_root} apps"
        
        # dummy main
        create_dir "#{deploy_root}/main"
        
        # remove default html and symbolic link
        run "rm -rf #{webroot_dir}/html"
        run "rm -rf /home/#{user}/html"
        
        # enable ruby
        ruby
        # activate the daemontools
        run "uberspace-setup-svscan" unless dir_exists? 'service'
        
        # done
        run "touch .ratchet"
      end  
    end # task :environment
    
    desc "Cleans the uberspace, removes (most) changes, restores the uberspace as much as possible"
    task :restore do
      run "mv bashrc.bak .bashrc"
      run "rm -rf .gem .gemrc .ratchet"
      
      # restore old html folder etc
      create_dir "#{webroot_dir}/html"
      run "ln -s #{webroot_dir}/html html/"
      
      # keep ./apps and ./aconf for now ...
    end # task :clean
    
  end # namespace
end
