
Capistrano::Configuration.instance.load do
  
  desc "Setup ruby interpreter and tools"
  namespace :setup do
    desc "Setup ruby interpreter and tools"
    task :ruby do
      
      # script to setup ruby
      ruby_script = <<-EOF

# ruby #{ruby_version} environment
export PATH=/package/host/localhost/ruby-#{ruby_version}/bin:$PATH
export PATH=$HOME/.gem/ruby/#{:ruby_api_version}/bin:$PATH
EOF

      # setup the ruby environment
      put ruby_script, "/home/#{user}/ruby_scrip"
      run "cat /home/#{user}/ruby_scrip >> /home/#{user}/.bashrc"
      
      # configure ruby
      run "echo 'gem: --user-install --no-rdoc --no-ri' > ~/.gemrc"
      run "gem install bundler"
      
      # cleanup
      run "rm /home/#{user}/ruby_scrip"
      
    end # task :ruby
  end
end