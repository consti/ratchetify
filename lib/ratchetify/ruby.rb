
Capistrano::Configuration.instance.load do
  
  desc "Setup ruby interpreter and tools"
  namespace :ruby do
    desc "Setup ruby interpreter and tools"
    task :default do
      run "pwd && whoami"
    end
  end
end