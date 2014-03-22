# Ratchetify

Ratchetify helps you deploy a Ruby on Rails app on Uberspace (uberspace.de), a really cool shared hosting provider.

All the magic is built into a couple nice Capistrano scripts. Ratchetify will create an environment for your app, run it in standalone mode, monitor it using Daemontools, and configure Apache to reverse-proxy to it. Ratchetify will also retrieve your MySQL password, create a dedicated database for your app and create a `database.yml`.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'ratchetify', :git => 'https://github.com/ratchetcc/ratchetify.git'
```

And then execute:

    $ bundle
    
This will install ratchetify, Capistrano 2.x and all dependent gems for you.

## How to use ratchetify

There is a sample [capfile](https://github.com/ratchetcc/ratchetify/blob/master/Capfile.example) that shows the most important settings you need to get started. In addition to the
attributes used in the Capfile, there are more attributes pre-set in lib/ratchetify.rb and lib/ratchetify/base.rb but usually there is no need to change any of these.

This tools is highly opinionated i.e. all the settings, the way how I run the app etc. are THE WAY I LIKE IT. This does not mean it can not be done differently or that it is the best way to do it ...

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
