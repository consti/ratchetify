
Capistrano::Configuration.instance.load do
  
  desc "Tasks to test the login credentials"
  namespace :test do
    desc "Test the login credentials"
    task :default do
      run "pwd && whoami"
    end
  end
end