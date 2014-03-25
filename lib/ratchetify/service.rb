
Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  
  desc "Tasks to start/stop/restart the app server"
  namespace :service do
    desc "Start the app server"
    task :start do
      run "svc -u ~/service/#{daemon_service}"
    end
    
    desc "Stop the app server"
    task :stop do
      run "svc -d ~/service/#{daemon_service}"
    end
    
    desc "Restart the app server"
    task :restart do
      run "svc -du ~/service/#{daemon_service}"
    end

    task :create do
      create_service_thin # the only option for now
      
      # register the service
      run "uberspace-setup-service #{daemon_service} ~/bin/#{daemon_service}"
      
    end # task :create_service

    task :create_service_thin do
      # script to start thin
      script = <<-EOF
#!/bin/bash
export HOME=/home/#{user}
source $HOME/.bash_profile
cd #{deploy_dir}
exec /home/#{user}/.gem/ruby/#{ruby_version}/bin/bundle exec thin start -p #{daemon_port} -e production 2>&1
EOF
      
      # upload the run script
      put script, "/home/#{user}/bin/#{daemon_service}"
      run "chmod 755 /home/#{user}/bin/#{daemon_service}"
      
    end # task :create_service_thin
    
    task :create_service_unicorn do
      # script to start unicorn
      script = <<-EOF
#!/bin/bash
export HOME=/home/#{user}
source $HOME/.bash_profile
cd #{deploy_dir}
exec /home/#{user}/.gem/ruby/#{ruby_version}/bin/bundle exec unicorn -p #{daemon_port} -c ./config/unicorn.rb -E #{environment} 2>&1
EOF
      
      # upload the run script
      put script, "/home/#{user}/bin/#{daemon_service}"
      run "chmod 755 /home/#{user}/bin/#{daemon_service}"
      
      # script to configure unicorn
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
  
      # upload the unicorn config file, if it does not exist
      put unicorn_rb, "#{deploy_dir}/config/unicorn.rb" unless file_exists? "#{deploy_dir}/config/unicorn.rb"
      
    end # task :create_service_unicorn
    
    desc "Remove the service"
    task :remove do
      script = <<-EOF
cd ~/service/#{daemon_service}
rm ~/service/#{daemon_service}
svc -dx . log
rm -rf ~/etc/run-#{daemon_service}
EOF

      # upload script
      put script, "/home/#{user}/rm-#{daemon_service}"
      run "chmod 755 /home/#{user}/rm-#{daemon_service}"
      
      # remove the service
      run ". ~/rm-#{daemon_service}"
      
      # cleanup
      run "rm /home/#{user}/rm-#{daemon_service}"
    end
    
  end
end