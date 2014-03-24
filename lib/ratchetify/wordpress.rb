
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/setup'
  require 'ratchetify/domain'
  
  before :create, "setup:environment"
  after :create, "domain:add"
  
  desc "Deploy an app for the first time"
  namespace :create do
    
    desc "Deploy an wordpress blog to uberspace"
    task :wordpress do
      create_dir
      create_database
    end
    
    
    task :create_dir do
      create_dir deploy_dir unless dir_exists? deploy_dir
    end # task :create_dir
    
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
    
  end # namespace
end
