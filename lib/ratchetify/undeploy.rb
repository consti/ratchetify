
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
      run "cd #{webroot_dir} && rm -rf #{fetch :domain}" unless (wildcard_domain == false)
    end
    
    task :remove_service do
      script = <<-EOF
cd ~/service/#{daemon_service}
rm ~/service/#{daemon_service}
svc -dx . log
rm -rf ~/etc/run-#{daemon_service}
EOF

      # upload script
      put script, "/home/#{user}/rm-#{daemon_service}"
      
      # remove the service
      run ". ~/rm-#{daemon_service}"
      
      # cleanup
      run "rm /home/#{user}/rm-#{daemon_service}"
      
    end
    
  end # namespace
end
