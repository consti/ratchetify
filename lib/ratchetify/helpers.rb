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
  shell "mkdir #{full_path}", use_sudo
  if owner != nil then
    shell "chown #{owner} #{full_path}", use_sudo
  end
end

def delete_dir(full_path)
  if dir_exists? full_path then
    shell "rm -Rf #{full_path}", use_sudo
  end
end

def delete_file(full_path)
  if file_exists? full_path then
    shell "rm #{full_path}", use_sudo
  end
end