
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/setup'
  require 'ratchetify/domain'
  
  before "create:php", "setup:environment"
  after "create:php", "domain:add"
  
  desc "Deploy an app for the first time"
  namespace :create do
    
    desc "Deploy an wordpress blog to uberspace"
    task :php do
      create_repo
      create_database
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
        
    task :create_database do
      
      # extract user & password
      my_cnf = capture('cat ~/.my.cnf')
      
      my_cnf.match(/^user=(\w+)/)
      mysql_user = $1
      my_cnf.match(/^password=(\w+)/)
      mysql_pwd = $1
      my_cnf.match(/^port=(\w+)/)
      mysql_port = $1
      
      # create the database
      mysql_database = "#{user}_#{application}" # 'application' MUST NOT contain any '-' !!!
      run "mysql -e 'CREATE DATABASE IF NOT EXISTS #{mysql_database} CHARACTER SET utf8 COLLATE utf8_general_ci;'"
      
      database_yml = <<-EOF
database: #{mysql_database}
username: #{mysql_user}
password: #{mysql_pwd}
host: localhost
port: #{mysql_port}

EOF

      # upload the database.yml file
      put database_yml, "#{deploy_dir}/database.yml"
      
    end # task :create_database
    
    task :finalize do
      # create symbolic links..
      run "cd #{webroot_dir} && ln -s #{deploy_dir} #{fetch :host}.#{fetch :domain}"
      run "cd #{webroot_dir} && ln -s #{deploy_dir} #{fetch :domain}" unless (wildcard_domain == false)
    end # task :finalize
    
  end # namespace
end
