
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  
  desc "Tasks to start/stop/restart the app server"
  namespace :service do
    desc "Start the app server"
    task :start do
      run "svc -u ~/service/#{daemon_service}"
    end
    
    desc "Stop the app server"
    task :stop do
      run "svc -d ~/service/#{daemon_service}"
    end
    
    desc "Restart the app server"
    task :restart do
      run "svc -du ~/service/#{daemon_service}"
    end
    
  end
end