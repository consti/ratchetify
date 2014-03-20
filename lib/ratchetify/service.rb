
Capistrano::Configuration.instance.load do
  
  desc "Tasks to start/stop/restart the thin server"
  namespace :service do
    desc "Start the thin server"
    task :start do
      run "svc -u ~/service/#{fetch :daemon_service}"
    end
    
    desc "Stop the thin server"
    task :stop do
      run "svc -d ~/service/#{fetch :daemon_service}"
    end
    
    desc "Restart the thin server"
    task :restart do
      run "svc -du ~/service/#{fetch :daemon_service}"
    end
    
  end
end