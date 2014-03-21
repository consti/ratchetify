
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/ruby'
  
  desc "Deploy an app for the first time"
  namespace :create do
    
    desc "Deploy an app to uberspace"
    task :default do
      #create_repo
      #create_service_and_proxy
      #create_and_configure_database
      config_web_app
    end
    
    task :create_repo do
      deploy_dir = "~/apps/#{application}"
      
      # clone the repo first
      git_cmd = "cd ~/apps && git clone #{fetch :repo} #{fetch :application}"
      
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
cd /var/www/virtual/#{user}/#{host}.#{domain}
exec /home/#{user}/.gem/ruby/#{ruby_version}/bin/bundle exec unicorn -p #{daemon_port} -c ./config/unicorn.rb 2>&1
EOF
      
      daemon_service = "run-#{application}"
      
      # upload the run script
      put script, "/home/#{user}/bin/#{daemon_service}"
      run "chmod 755 /home/#{user}/bin/#{daemon_service}"
      
      # place the .htaccess file
      put htaccess, "#{deploy_dir}/.htaccess"
      run "chmod +r #{deploy_dir}/.htaccess"
      
      # register the service
      run "uberspace-setup-service #{daemon_service} ~/bin/#{daemon_service}"
      
    end
  
    task :create_and_configure_database do
      
      # extract user & password
      my_cnf = capture('cat ~/.my.cnf')
      
      my_cnf.match(/^user=(\w+)/)
      mysql_user = $1
      my_cnf.match(/^password=(\w+)/)
      mysql_pwd = $1
      
      mysql_database = "#{user}_#{application}" # 'application' MUST NOT contain any '-' !!!
      run "mysql -e 'CREATE DATABASE IF NOT EXISTS #{mysql_database} CHARACTER SET utf8 COLLATE utf8_general_ci;'"
      
      # create the database.yml file
      database_yml = <<-EOF
production:
  adapter: mysql2
  encoding: utf8
  database: #{mysql_database}
  pool: 15
  username: #{mysql_user}
  password: #{mysql_pwd}
  host: localhost
  socket: /var/lib/mysql/mysql.sock
  timeout: 10000

EOF
      # upload the database.yml file
      put database_yml, "#{deploy_dir}/config/database.yml"
      
    end
    
    task :config_web_app do
      
      unicorn_rb = <<-EOF
# config/unicorn.rb
worker_processes 3
timeout 15
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end      
EOF
  
      # upload the database.yml file
      put unicorn_rb, "#{deploy_dir}/config/unicorn.rb"
      
    end
    
  end # namespace
end
