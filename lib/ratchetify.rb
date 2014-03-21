require "ratchetify/version"

Capistrano::Configuration.instance.load do
  
  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/setup'
  require 'ratchetify/ruby'
  require 'ratchetify/create'
  require 'ratchetify/service'
  
  # host and domain for the new app
  set :domain, nil
  set :host, nil
  
  # random port used for the reverse proxy
  set :daemon_port, rand(61000-32768+1)+32768  # random port
  
  # internal variables, should not be changed in the cap file
  set :home, "~"
  set :app_dir, "#{home}/apps"
  set :conf_dir, "#{home}/aconf"
  set :ruby_version, "2.0.0"
  set :environment, 'production'
  
end
