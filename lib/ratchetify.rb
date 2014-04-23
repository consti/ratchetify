require 'ratchetify/version'

Capistrano::Configuration.instance.load do

  require 'capistrano'
  require 'ratchetify/helpers'
  require 'ratchetify/setup'
  require 'ratchetify/ruby'
  require 'ratchetify/service'
  require 'ratchetify/undeploy'
  require 'ratchetify/domain'
  require 'ratchetify/rails'
  require 'ratchetify/wordpress'
  require 'ratchetify/update'
  require 'ratchetify/help' # monkey patched from capistrano

  # host and domain for the new app
  set :domain, nil
  set :host, nil
  set :wildcard_domain, false

  # random port used for the reverse proxy
  set :daemon_port, rand(61000-32768+1)+32768  # random port
  set :type, :rails # supported types are: :rails, :wordpress,

  # internal variables, should not be changed in the cap file
  set :ruby_version, "2.1.1"
  set :ruby_api_version, "2.1.0"
  set :environment, 'production'
  set :is_main,  false

end
