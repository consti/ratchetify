
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  
  desc "Tasks to add/remove domains (web only)"
  namespace :domain do
    
    desc "Add a fully qualified domain and wildcard domain if specified"
    task :add do
      run "uberspace-add-domain -d #{host}.#{domain} -w"
      run "uberspace-add-domain -d #{domain} -w" unless (wildcard_domain == false)
    end
    
    desc "Removes a fully qualified domain and wildcard domain if specified"
    task :remove do
      run "uberspace-del-domain -d #{host}.#{domain} -w"
      run "uberspace-del-domain -d #{domain} -w" unless (wildcard_domain == false)
    end
        
  end
end