
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  
  desc "Undeploy an app from uberspace"
  namespace :undeploy do
    
    desc "Undeploy an app from uberspace"
    task :default do
      drop_database
      remove_repo
      remove_service
    end
    
    task :drop_database do
      mysql_database = "#{user}_#{application}" # 'application' MUST NOT contain any '-' !!!
      run "mysql -e 'DROP DATABASE IF EXISTS #{mysql_database};'"
    end
    
    task :remove_repo do
      run "cd #{deploy_root} && rm -rf #{fetch :application}"
      run "cd #{webroot_dir} && rm -rf #{fetch :host}.#{fetch :domain}"
    end
    
    task :remove_service do
      # ** [out :: sirius.uberspace.de] cd ~/service/run-fatfreecrm
      # ** [out :: sirius.uberspace.de] rm ~/service/run-fatfreecrm
      # ** [out :: sirius.uberspace.de] svc -dx . log
      # ** [out :: sirius.uberspace.de] rm -rf ~/etc/run-run-fatfreecrm
       
      #run "cd service && rm ~/service/#{daemon_service}"
      #run "svc -dx #{daemon_service}"
      #run "rm -rf ~/etc/run-#{daemon_service}"
    end
    
  end # namespace
end
