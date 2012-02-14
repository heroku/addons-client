# Addons::Client

This gem is used for calls to the Add-on Platform API so that Platforms as a Service
can make use of the add-ons ecosystem.

The 3 main API operations are provisioning, deprovisiong, and changing the plan of 
an add-on.  They are all supported via a Ruby Client and a command line interface.

## Installation

Add this line to your application's Gemfile:

    gem 'addons-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install addons-client

## Usage

```ruby
client = Addons::Client.new(:username => 'test',
                            :password => 'pass',
                            :salt     => 'salt') 

client.provision! 'memcache:5mb'
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
