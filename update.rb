
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
      # switch to the specified branch
      run "cd #{deploy_dir} && git checkout -b #{fetch :branch}" unless on_branch? deploy_dir, "#{fetch :branch}"
      
      # update the repo
      git_cmd = "cd #{deploy_root} && git pull origin #{fetch :branch}"
      
      run git_cmd do |channel, stream, out|
        if out =~ /Password:/
          channel.send_data("#{fetch :repo_password}\n")
        else
          puts out
        end
      end
      
      #
      # typical RAILS stuff to finalize
      #
      
      # run bundle install first
      run "cd #{deploy_dir} && bundle install --path ~/.gem"
      
      # run rake db:migrate to create all tables etc
      run "cd #{deploy_dir} && bundle exec rake db:migrate RAILS_ENV=#{fetch :environment}"
      
      # compile assets from the asset pipeline
      run "cd #{deploy_dir} && bundle exec rake assets:precompile RAILS_ENV=#{fetch :environment}"
      
    end # end task :default
    
  end
end