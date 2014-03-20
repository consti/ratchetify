
Capistrano::Configuration.instance.load do

  desc "Git tasks"
  namespace :git do

    desc "Pull the latest version from git (github/bitbucket etc)"
    task :pull do
      git_cmd = "cd #{fetch :application_home} && git pull origin #{fetch :branch}"
      
      run git_cmd do |channel, stream, out|
        if out =~ /Password:/
          channel.send_data("#{fetch :scm_password}\n")
        else
          puts out
        end
      end
   
    end
    
    desc "Push any changes back to origin (github/bitbucket etc)"
    task :push do
      git_cmd = "cd #{fetch :application_home} && git push origin #{fetch :branch}"
      
      run git_cmd do |channel, stream, out|
        if out =~ /Password:/
          channel.send_data("#{fetch :scm_password}\n")
        else
          puts out
        end
      end
   
    end
        
  end
end