
require 'bundler/capistrano'

def abort_red(msg)
  abort "  * \e[#{1};31mERROR: #{msg}\e[0m"
end

Capistrano::Configuration.instance.load do

  # required variables
  _cset(:user)                  { abort_red "Please configure your Uberspace user using 'set :user, <username>'" }
  _cset(:repository)            { abort_red "Please configure your code repository using 'set :repository, <repo uri>'" }

  # optional variables
  _cset(:domain)                { nil }
  _cset(:host)                  { nil }
  _cset(:daemon_port)           { rand(61000-32768+1)+32768 } # random ephemeral port


  # internal variables, don't mess with them unsless you know what you do !
  set(:home)                    { "/home/#{user}" }
  #set(:app_dir)                 { "#{home}/apps" }
  #set(:conf_dir)                { "#{home}/aconf" }
  
  ssh_options[:forward_agent] = true
  default_run_options[:pty]   = true # allow pseudo-terminals
  
#
# old stuff
#

  # other variables
  _cset(:deploy_via)            { :remote_cache }
  _cset(:git_enable_submodules) { 1 }
  _cset(:branch)                { 'master' }

  _cset(:keep_releases)         { 3 }

  # uberspace presets
  #set(:deploy_to)               { "/var/www/virtual/#{user}/html" }
  #set(:use_sudo)                { false }

  

end
