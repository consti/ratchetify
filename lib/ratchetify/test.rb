
Capistrano::Configuration.instance.load do
  
  desc "Tasks to start/stop/restart the thin server"
  namespace :test do
    desc "Test the connectivity to uberspace.de"
    task :default do
      run "pwd && whoami"
    end
  end
end