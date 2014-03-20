
Capistrano::Configuration.instance.load do
  
  desc "Tasks to prepare a uberspace for deployment"
  namespace :setup do
    
    desc "Tasks to prepare a uberspace for deployment"
    task :default do
      ruby
      init_repo
      reverse_proxy
      daemon_tools
      finalize
    end
    
    desc "Setup ruby interpreter and tools"
    task :ruby do
      
      # script to setup ruby
      ruby_script = <<-EOF

# ruby #{ruby_version} environment
export PATH=/package/host/localhost/ruby-#{ruby_version}/bin:$PATH
export PATH=$HOME/.gem/ruby/#{ruby_version}/bin:$PATH
EOF

      # setup the ruby environment
      put ruby_script, "/home/#{user}/ruby_scrip"
      run "cat /home/#{user}/ruby_scrip >> /home/#{user}/.bashrc"
      
      # configure ruby
      run "echo 'gem: --user-install --no-rdoc --no-ri' > ~/.gemrc"
      run "gem install bundler"
      #run "bundle install --path ~/.gem" # FIXME ?
      
      # cleanup
      run "rm /home/#{user}/ruby_scrip"
      
    end
    
    desc "Setup daemon tools"
    task :daemon_tools do
      # activate the daemontools
      run "uberspace-setup-svscan"
      run "uberspace-setup-service #{daemon_service} ~/bin/#{daemon_service}"
    end
    
    desc "Initialize the repo, add server specific files"
    task :init_repo do
      #
      # template for the database.yml
      #
      my_cnf = capture('cat ~/.my.cnf')
      
      my_cnf.match(/^user=(\w+)/)
      mysql_user = $1
      my_cnf.match(/^password=(\w+)/)
      mysql_pwd = $1
      
      database_yml = <<-EOF
production:
  adapter: mysql2
  encoding: utf8
  database: #{mysql_user}
  pool: 15
  username: #{mysql_user}
  password: #{mysql_pwd}
  host: localhost
  socket: /var/lib/mysql/mysql.sock
  timeout: 10000

EOF

      # clone the repo first
      git_cmd = "git clone #{fetch :repository}"
      
      run git_cmd do |channel, stream, out|
        if out =~ /Password:/
          channel.send_data("#{fetch :scm_password}\n")
        else
          puts out
        end
      end
      
      # move repo to html
      run "rm -rf #{fetch :application_home}"
      run "mv #{fetch :application} #{fetch :application_home}"
      
      # switch branch
      git_cmd = "cd #{fetch :application_home} && git checkout -b #{fetch :branch}"
      
      # upload the database.yml file
      put database_yml, "/home/#{user}/#{application_home}/config/database.yml"
      
    end
    
    desc "Setup Apache reverse-proxy (.htaccess) & thin"
    task :reverse_proxy do
           
      # script to setup ruby
      thin_script = <<-EOF
#!/bin/bash
export HOME=/home/#{user}
source $HOME/.bash_profile
cd /var/www/virtual/#{user}/html
exec /home/#{user}/.gem/ruby/#{ruby_version}/bin/bundle exec thin start -p #{daemon_port} -e production 2>&1
EOF

      htaccess = <<-EOF
RewriteEngine On
RewriteBase /
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^(.*)$ http://localhost:#{daemon_port}/$1 [P]
      
EOF

      # upload the thin script
      put thin_script, "/home/#{user}/bin/#{daemon_service}"
      run "chmod 755 /home/#{user}/bin/#{daemon_service}"
      
      # place the .htaccess file
      put htaccess, "/home/#{user}/#{application_home}/.htaccess"
      run "chmod +r /home/#{user}/#{application_home}/.htaccess"
      
    end
    
    desc "Run bundle, initialize the database, compile assets etc. "
    task :finalize do
      # run bundle install first
      run "cd #{fetch :application_home} && bundle install --path ~/.gem"
      
      # run rake db:migrate to create all tables etc
      run "cd #{fetch :application_home} && bundle exec rake db:migrate RAILS_ENV=#{fetch :environment}"
      
      # run rake db:seed to load seed data
      run "cd #{fetch :application_home} && bundle exec rake db:seed RAILS_ENV=#{fetch :environment}"
      
      # compile assets from the asset pipeline
      run "cd #{fetch :application_home} && bundle exec rake assets:precompile RAILS_ENV=#{fetch :environment}"
      
      # create symbolic links so that apache will find the assets
      run "cd #{fetch :application_home} && ln -s public/assets assets"
    end
    
  end
end