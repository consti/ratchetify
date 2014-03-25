
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/setup'
  require 'ratchetify/domain'
  require 'ratchetify/service'
  
  before "create:rails", "setup:environment"
  after "create:rails", "service:create"
  after "create:rails", "domain:add"
  
  desc "Deploy an app for the first time"
  namespace :create do
    
    desc "Deploy an RAILS app to uberspace"
    task :rails do
      create_repo
      create_and_configure_database
      create_reverse_proxy
      config_rails_app
      finalize
    end
    
    task :create_repo do
      # clone the repo first
      git_cmd = "cd #{deploy_root} && git clone #{fetch :repo} #{fetch :application}"
      
      run git_cmd do |channel, stream, out|
        if out =~ /Password:/
          channel.send_data("#{fetch :repo_password}\n")
        else
          puts out
        end
      end
      
      # switch to the specified branch
      run "cd #{deploy_dir} && git checkout -b #{fetch :branch}" unless on_branch? deploy_dir, "#{fetch :branch}"
      
    end # task :create_repo
    
    task :create_and_configure_database do
      
      # extract user & password
      my_cnf = capture('cat ~/.my.cnf')
      
      my_cnf.match(/^user=(\w+)/)
      mysql_user = $1
      my_cnf.match(/^password=(\w+)/)
      mysql_pwd = $1
      
      # create the database
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
      
    end # task :create_and_configure_database
    
    task :create_reverse_proxy do
      
      # .htaccess      
      htaccess = <<-EOF
RewriteEngine On
RewriteBase /
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^(.*)$ http://localhost:#{daemon_port}/$1 [P]
EOF

      # place the .htaccess file
      put htaccess, "#{deploy_dir}/.htaccess"
      run "chmod +r #{deploy_dir}/.htaccess"
      
    end # task :create_reverse_proxy
    
    task :config_rails_app do
      # run bundle install first
      run "cd #{deploy_dir} && bundle install --path ~/.gem"

      # application.yml should normally be on the .gitignore list, however you application might need 
      # a basic configuration file to e.g. load seed data. Provide such a basic file as 'application.example.yml'
      # and it will be used to configure the app initially.
      
      # create a default application.yml file if non was provided
      if not file_exists? "#{deploy_dir}/config/application.yml"
        run "cd #{deploy_dir}/config && cp application.example.yml application.yml"
      end
      
      # run rake db:migrate to create all tables etc
      run "cd #{deploy_dir} && bundle exec rake db:migrate RAILS_ENV=#{fetch :environment}"
      
      # run rake db:seed to load seed data
      run "cd #{deploy_dir} && bundle exec rake db:seed RAILS_ENV=#{fetch :environment}"
      
      # compile assets from the asset pipeline
      run "cd #{deploy_dir} && bundle exec rake assets:precompile RAILS_ENV=#{fetch :environment}"
      
      # create symbolic links so that apache will find the assets
      run "cd #{deploy_dir} && ln -s public/assets assets"
    end
    
    task :finalize do
      # create symbolic links..
      run "cd #{webroot_dir} && ln -s #{deploy_dir} #{fetch :host}.#{fetch :domain}"
      run "cd #{webroot_dir} && ln -s #{deploy_dir} #{fetch :domain}" unless (wildcard_domain == false)
    end
    
  end # namespace
end
