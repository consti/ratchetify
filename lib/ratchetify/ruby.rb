
Capistrano::Configuration.instance.load do
  
  desc "Setup ruby interpreter and tools"
  namespace :setup do
    desc "Setup ruby interpreter and tools"
    task :ruby do
      run "pwd && whoami"
    end
  end
end