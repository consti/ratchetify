
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/ruby'
  
  desc "Deploy an app for the first time"
  namespace :create do
    
    desc "Deploy an app to uberspace"
    task :default do
      clone_repo
    end
    
    task :clone_repo do
      deploy_dir = "~/apps/#{application}"
      
      # clone the repo first
      git_cmd = "cd ~/apps && git clone #{fetch :repo}"
      
      run git_cmd do |channel, stream, out|
        if out =~ /Password:/
          channel.send_data("#{fetch :repo_password}\n")
        else
          puts out
        end
      end
      
      # switch to the specified branch
      run "cd #{deploy_dir} && git checkout -b #{fetch :branch}" unless on_branch? deploy_dir, "#{fetch :branch}"
      
    end
    
  end # namespace
end
