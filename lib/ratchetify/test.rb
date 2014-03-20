
Capistrano::Configuration.instance.load do
  
  desc "Tasks to test the login credentials"
  namespace :login_test do
    desc "Test the login credentials and print some usefull stuff..."
    task :default do
      run "pwd && whoami"
    end
  end
end