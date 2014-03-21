
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  
  desc "Undeploy an app from uberspace"
  namespace :undeploy do
    
    desc "Undeploy an app from uberspace"
    task :default do
      remove_service
      #drop_database
      #remove_repo
    end
    
    task :drop_database do
      mysql_database = "#{user}_#{application}" # 'application' MUST NOT contain any '-' !!!
      run "mysql -e 'DROP DATABASE IF EXISTS #{mysql_database};'"
    end
    
    task :remove_repo do
      run "cd #{deploy_root} && rm -rf #{application}"
      run "cd #{webroot_dir} && rm -rf #{host}.#{domain}"
    end
    
    task :remove_service do
      run "cd service && rm ~/service/#{daemon_service}"
      #run "svc -dx #{daemon_service}"
      run "rm -rf ~/etc/run-#{daemon_service}"
    end
    
  end # namespace
end
