
require 'bundler/capistrano'

def abort_red(msg)
  abort "  * \e[#{1};31mERROR: #{msg}\e[0m"
end

Capistrano::Configuration.instance.load do

  # required variables
  _cset(:user)                  { abort_red "Please configure your Uberspace user using 'set :user, <username>'" }
  _cset(:repository)            { abort_red "Please configure your code repository using 'set :repository, <repo uri>'" }
  
  # other variables
  _cset(:deploy_via)            { :remote_cache }
  _cset(:branch)                { 'master' }
  
  # internal variables, don't mess with them unsless you know what you do !
  set(:use_sudo)                { false }
  ssh_options[:forward_agent] = true # use the keys for the person running the cap command to check out the app
  default_run_options[:pty]   = true # needed for git password prompts
  
end
