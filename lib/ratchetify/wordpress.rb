
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/setup'
  require 'ratchetify/domain'
  
  before "create:wordpress", "setup:environment"
  after "create:wordpress", "domain:add"
  
  desc "Deploy an app for the first time"
  namespace :create do
    
    desc "Deploy an wordpress blog to uberspace"
    task :wordpress do
      create_web_dir
      create_database
      finalize
    end
    
    
    task :create_web_dir do
      # download the worpress .tar
      unless dir_exists? deploy_dir
        # download wp and unpack it
        run "cd #{webroot_dir} && curl -O https://s3-eu-west-1.amazonaws.com/ratchetp/wordpress-3.8.1.tar.gz"
        #run "cd #{deploy_root} && mkdir wp_tmp"
        run "cd #{webroot_dir} && tar xfz wordpress* -C #{deploy_root}"
        run "cd #{deploy_root} && mv wordpress #{application}"
        
        # cleanup
        #run "cd #{deploy_root} && rm wordpress*"
        run "cd #{webroot_dir} && rm -rf wordpress*"
        
        # rename word press to -> :application
        #run "cd #{deploy_root} && mv ./wordpress #{application}"
      end
      
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
    
    task :finalize do
      # create symbolic links..
      run "cd #{webroot_dir} && ln -s #{deploy_dir} #{fetch :host}.#{fetch :domain}"
      run "cd #{webroot_dir} && ln -s #{deploy_dir} #{fetch :domain}" unless (wildcard_domain == false)
    end # task :finalize
    
  end # namespace
end
