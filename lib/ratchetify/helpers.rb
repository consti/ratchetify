#
# usefull methods that make life easier
#

#
# dirs and other constants
#

def webroot_dir
  "/var/www/virtual/#{user}"
end

def deploy_root
  "#{web_root}/apps"
end

def deploy_dir
  "#{deploy_root}/#{application}"
end

def conf_dir
  "/home/#{user}/aconf"
end 

def daemon_service
  "run-#{application}"
end

#
# file and dir handling
#

def file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

def dir_exists?(full_path)
  'true' ==  capture("if [ -d #{full_path} ]; then echo 'true'; fi").strip
end

def create_dir(full_path, owner=nil)
  run "mkdir #{full_path} -p"
  if owner
    run "chown #{owner} #{full_path}"
  end
end

def delete_dir(full_path)
  if dir_exists? full_path
    run "rm -Rf #{full_path}"
  end
end

def delete_file(full_path)
  if file_exists? full_path 
    run "rm #{full_path}"
  end
end

#
# working with git
#
def branch?(full_path)
  capture("cd #{full_path} && git branch | grep '*'")
end

def on_branch?(full_path, branch)
  "* #{branch}" == capture("cd #{full_path} && git branch | grep '*'")
end