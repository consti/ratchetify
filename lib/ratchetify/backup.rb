
Capistrano::Configuration.instance.load do

  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/service'

  desc "Tasks to backup an app"
  namespace :backup do
    desc "Create a DB backup in your home folder on uberspace"
    task :db do
        # extract username
        my_cnf = capture('cat ~/.my.cnf')

        my_cnf.match(/^user=(\w+)/)
        user = $1

        # database name
        postgres_database = "#{user}_#{application}"
        filename = "~/#{ postgres_database }-#{ Time.now.to_i }.sql.gz"
        transfer :down, filename, filename, :via => :scp

        run "cd #{deploy_dir} && pg_dump #{ postgres_database } | gzip > #{ filename }"
        puts "Backup of #{ postgres_database } created: #{ filename }"
    end
    desc "Run all other backup tasks"
    task :default do
      db
    end

  end
end
