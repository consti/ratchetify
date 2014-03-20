
Capistrano::Configuration.instance.load do
  
  desc "Common rake tasks"
  namespace :rake do
    
    desc "rake db:create"
    task :create do
      run "cd #{fetch :application_home} && bundle exec rake db:create RAILS_ENV=#{fetch :environment}"
    end
    
    desc "rake db:setup"
    task :setup do
      run "cd #{fetch :application_home} && bundle exec rake db:setup RAILS_ENV=#{fetch :environment}"
    end
    
    desc "rake db:seed"
    task :seed do
      run "cd #{fetch :application_home} && bundle exec rake db:seed RAILS_ENV=#{fetch :environment}"
    end
    
    desc "rake db:migrate"
    task :migrate do
      run "cd #{fetch :application_home} && bundle exec rake db:migrate RAILS_ENV=#{fetch :environment}"
    end
    
    desc "rake assets:precompile"
    task :precompile do
      run "cd #{fetch :application_home} && bundle exec rake assets:precompile RAILS_ENV=#{fetch :environment}"
    end
    
  end
end