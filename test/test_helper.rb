require 'test/unit'
Bundler.require :test
require 'webmock/test_unit'
require_relative '../lib/addons-client'

class Addons::Client::TestCase < Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def setup
    ENV['ADDONS_API_SALT']     = 'salt'
    ENV['ADDONS_API_PASSWORD'] = 'bacon'
  end

  def teardown
    WebMock.reset!
  end

  def addons_client! cmd
    stub(Settings).rest { cmd.split }
    Addons::CLI.run!
  end
end
