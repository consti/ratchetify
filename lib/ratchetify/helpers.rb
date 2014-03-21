#
# usefull methods that make life easier
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