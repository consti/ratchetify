
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/service'
  
  before :update, "service:stop"
  after :update, "service:start"
  
  desc "Tasks to update an app"
  namespace :update do
    
    desc "Stop the service, update the app then restart"
    task :default do
      puts "updating"
    end # end task :default
    
  end
end