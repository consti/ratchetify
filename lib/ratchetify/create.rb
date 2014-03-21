
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/ruby'
  
  desc "Deploy an app for the first time"
  namespace :create do
    
    desc "Deploy an app to uberspace"
    task :default do
      #create_repo
      create_service_and_proxy
    end
    
    task :create_repo do
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
    
    task :create_service_and_proxy do
      
      # .htaccess      
      htaccess = <<-EOF
RewriteEngine On
RewriteBase /
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^(.*)$ http://localhost:#{daemon_port}/$1 [P]
EOF
      
      # script to start app
      script = <<-EOF
#!/bin/bash
export HOME=/home/#{user}
source $HOME/.bash_profile
cd /var/www/virtual/#{user}/apps/#{application}
exec /home/#{user}/.gem/ruby/#{ruby_version}/bin/bundle exec unicorn -p #{daemon_port} -c ./config/unicorn.rb 2>&1
EOF
      
      deploy_dir = "~/apps/#{application}"
      daemon_service = "run-#{application}"
      
      # upload the run script
      put script, "/home/#{user}/bin/#{daemon_service}"
      run "chmod 755 /home/#{user}/bin/#{daemon_service}"
      
      # register the service
      run "uberspace-setup-service #{daemon_service} ~/bin/#{daemon_service}"
      
      # place the .htaccess file
      put htaccess, "#{deploy_dir}/.htaccess"
      run "chmod +r #{deploy_dir}/.htaccess"
      
    end
  
  end # namespace
end
