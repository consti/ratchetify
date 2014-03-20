
Capistrano::Configuration.instance.load do
  
  desc "Tasks to test the login credentials"
  namespace :login_test do
    desc "Test the login credentials"
    task :default do
      run "echo Lets' see ..."
      run "pwd && whoami"
    end
  end
end