
Capistrano::Configuration.instance.load do

  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/service'

  desc "Tasks to backup an app"
  namespace :backup do
    desc :db do
        # extract username
        my_cnf = capture('cat ~/.my.cnf')

        my_cnf.match(/^user=(\w+)/)
        user = $1

        # database name
        postgres_database = "#{user}_#{application}"
        filename = "~/#{ postgres_database }-#{ Time.now.to_s }.sql.gz"

        run "cd #{deploy_dir} && pg_dump #{ postgres_database } | gzip > #{ filename }"
        puts "Backup of #{ postgres_database } created: #{ filename }"
    end
    desc "Stop the service, update the app then restart"
    task :default do
      db
    end

  end
end
