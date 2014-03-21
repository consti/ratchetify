#
# usefull methods that make life easier
#

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
  run "mkdir #{full_path}"
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