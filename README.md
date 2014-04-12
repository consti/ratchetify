# Ratchetify

Ratchetify helps you deploy a Ruby on Rails app on Uberspace (uberspace.de), a really cool shared hosting provider.

All the magic is built into a couple of capistrano scripts. Ratchetify creates an environment for your app (folders, ruby, bundler etc) and then pulls the app from e.g. github or bitbucket. To instantly run the app, ratchetify creates a database and matching database.yml file, adds a .htaccess file to the app's root folder (so that Apache can reverse-proxy all requests) and finally runs the typical rake tasks (db:create, db:migrate, etc) to get going. 

The app is serverd by the Unicorn app server and monitored by Uberspace's daemontools.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'ratchetify'
```

And then execute:

    $ bundle install
    
This will install ratchetify and all its dependencies for you.

## How to use ratchetify

There is a sample [capfile](https://github.com/ratchetcc/ratchetify/blob/master/Capfile.example) that shows the most important settings you need to get started. In addition to the attributes used in the Capfile, there are more attributes pre-set in lib/ratchetify.rb and lib/ratchetify/base.rb but usually there is no need to change any of these.

This tools is highly opinionated i.e. all the settings, the way how the app is deployed and run etc., ARE THE WAY I LIKE IT ! :-)

The first time ratchetify is used on a fresh uberspace, it creates some folders and symbolic links from your home directory to these folders. The ~/html folder that by default hosts e.g. a static .html app is removed. The reason for this is that ratchetify allows you to deploy and run many apps side-by-side, within a single uberspace.

### Basic commands

To get started with a new Rails app, use:

```shell
$ rat create:rails
```

This prepares your uberspace if it is the first time you deploy an app using ratchetify, pulls your app from a repo, creates a database and database.yml for it, creates a run-script and registers it with uberspace's daemontools and finally runs the typical rake tasks needed to setup a RAILS app.

Ratchetify also registers your app's host-name and domain with the Apache webserver, you only have to make sure that your DNS entries point to the right uberspace.

To update an app, use:

```shell
$ rat update
```

This stops the app, pulls the latest version from the repo, runs basic rake tasks and finally restarts the app.

To remove an app use:

```shell
$ rat remove
```

This stops the app, deletes its database and removes it from the file system. Be careful here, there is no way back!

Ratchetify is based on Capistrano and you can get a list of all available commands any time using:

```shell
$ rat -T
```

## Credits

The original gem was created by [Jan Schulz-Hofen](https://github.com/yeah/uberspacify). 

## License

MIT; Copyright (c) 2014 ratchet.cc

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
