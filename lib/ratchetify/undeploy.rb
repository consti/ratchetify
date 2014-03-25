
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/service'
  
  before "undeploy", "service:remove"
  
  desc "Undeploy an app from uberspace"
  namespace :undeploy do
    
    desc "Undeploy an app from uberspace"
    task :default do
      drop_database
      remove_repo
    end
    
    task :drop_database do
      mysql_database = "#{user}_#{application}" # 'application' MUST NOT contain any '-' !!!
      run "mysql -e 'DROP DATABASE IF EXISTS #{mysql_database};'"
    end
    
    task :remove_repo do
      run "cd #{deploy_root} && rm -rf #{fetch :application}"
      run "cd #{webroot_dir} && rm -rf #{fetch :host}.#{fetch :domain}"
      run "cd #{webroot_dir} && rm -rf #{fetch :domain}" unless (wildcard_domain == false)
    end
    
  end # namespace
end
