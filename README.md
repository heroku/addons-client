# Addons::Client

[![Build Status](https://secure.travis-ci.org/heroku/addons-client.png?branch=master)](http://travis-ci.org/heroku/addons-client)

## codename: Kaikei

The addons client is a Ruby library that creates the RESTful requests that are used to interact with the Add-on Platform API.

The Platform API provides 3 main functions for Add-ons: provisioning, deprovisioning, and plan change.
Historically, the heroku module "core" was responsible for sending the appropriate messages to
add-on providers and reacting correctly according to those responses. Core will still have to react
to api errors, but will no longer send messages to providers.

The Addons Client represents the first attempt at having a well-defined interface between a Platform and these
add-on related API interactions. It is an implementation of the following API: https://gist.github.com/079c98529d399bb08c7a

Also, we have provided a command line client (the real first consumer of the API) so we could issue API requests
to the add-ons app without having to fire up a console session.

## Installation

### make a test directory

    mkdir client-test
    cd client-test

### make a Gemfile with the gem on github

    echo "source :rubygems" > Gemfile
    echo "gem 'addons-client', :git => 'git@github.com:heroku/addons-client.git'" >> Gemfile

### use bundler to install the Gem from github

    bundle install

### set up ENV

    export ADDONS_API_URL=https://heroku:password@localhost:3000

### it works
   
    bundle exec addons-client  
    Command must be one of: provision, deprovision, planchange    

Remember to use bundle exec to run the command line commands!

## Ruby Usage

```ruby
client = Addons::Client.new
 # Addons::UserError: ADDONS_API_URL must be set

ENV['ADDONS_API_URL']='http://heroku:password@localhost:3000'

client = Addons::Client.new
```

### API Methods 
```ruby
client.provision! 'memcache:5mb'

client.provision! 'foo:bar', :consumer_id => 'app123@heroku.com',
  :options => { :foo => 'bar', 'baz' => 'test' } 

  # => {:resource_id=>"DEADBEEF", 
  #     :config=>{"FOO_URL"=>"http://foo.com"}, 
  #     :message=>"great success", 
  #     :provider_id=>"ABC123"} 

client.plan_change! 'ABC123', 'new_plan'

client.deprovision! 'ABC123'
```

##  Command Line Usage
    export ADDONS_API_URL=http://heroku:password@localhost:3000

    addons-client provision memcache:5mb --consumer-id=app123@heroku.com --options.foo=bar --options.baz=true

#### Provisioning:

    addons-client provision glenntest:test 
    {"resource_id":"3bdb228d-a94e-4135-b19f-7a17a9f4f481","config":null,"message":null,"provider_id":null} 

### use the resource id to interact with the add-on

    addons-client plan_change 0dedb8f4-2921-42b8-81b9-a7df4c551140 test

    addons-client deprovision 0dedb8f4-2921-42b8-81b9-a7df4c551140
    Deprovisioned 0dedb8f4-2921-42b8-81b9-a7df4c551140 

### fun with options

    addons-client provision foo-bar:test --consumer_id=resource123@heroku.com --options.message='Good job'


## enabling api requests
    Notice the provider_id is null.
    This is because we won't send live requests until we've enabled the switch.
    And also because in a later story we will want to have this toggleable on a per-request basis.  

    heroku config:add PROVIDER_API_ENABLED=true --app addons-staging 

### it should now create a resource with a provider_id

    addons-client provision foo-bar:test
    Provisioned foo-bar:test
    {"resource_id":"0dedb8f4-2921-42b8-81b9-a7df4c551140","config":{"MYADDON_URL":"http://user.yourapp.com"},"message":null,"provider_id":2}

## Test Usage

The client supports a mocked mode that sends no requests and returns canned responses.

```ruby
Addons::Client.mock!
Addons::Client.new.provision! 'foo:bar' 
  # => {:resource_id=>"DEADBEEF", 
  #     :config=>{"FOO_URL"=>"http://foo.com"}, 
  #     :message=>"great success", 
  #     :provider_id=>"ABC123"} 

Addons::Client.unmock!
Addons::Client.new.provision! 'foo:bar'
 # Addons::UserError: ADDONS_API_URL must be set
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
