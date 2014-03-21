
require 'bundler/capistrano'

def abort_red(msg)
  abort "  * \e[#{1};31mERROR: #{msg}\e[0m"
end

Capistrano::Configuration.instance.load do

  # required variables
  _cset(:user)                  { abort_red "Please configure your Uberspace user using 'set :user, <username>'" }
  _cset(:repository)            { abort_red "Please configure your code repository using 'set :repository, <repo uri>'" }

  

  # internal variables, don't mess with them unsless you know what you do !
  _cset(:deploy_via)            { :remote_cache }
  set(:use_sudo)                { false }
  ssh_options[:forward_agent] = true # use the keys for the person running the cap command to check out the app
  default_run_options[:pty]   = true # needed for git password prompts
  
#
# old stuff
#

  # other variables
  
  _cset(:git_enable_submodules) { 1 }
  _cset(:branch)                { 'master' }

  _cset(:keep_releases)         { 3 }

  # uberspace presets
  #set(:deploy_to)               { "/var/www/virtual/#{user}/html" }
  #set(:use_sudo)                { false }

  

end
