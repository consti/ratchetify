
Capistrano::Configuration.instance.load do
  
  desc "Common bundle tasks"
  namespace :bundle do
    
    desc "bundle install"
    task :install do
      run "cd #{fetch :application_home} && bundle install --path ~/.gem"
    end
    
    desc "bundle update"
    task :update do
      run "cd #{fetch :application_home} && bundle update --path ~/.gem"
    end
    
  end
end