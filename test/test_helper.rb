require 'test/unit'
Bundler.require :test

require_relative '../lib/addons-client'

class Addons::Client::TestCase < Test::Unit::TestCase
  include RR::Adapters::TestUnit
end
