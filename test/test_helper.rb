require 'test/unit'
require 'minitest/spec'
require 'minitest/autorun'
Bundler.require :test
require 'webmock/test_unit'
require_relative '../lib/addons-client'

class Addons::Client::TestCase < Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def setup
  end

  def teardown
    WebMock.reset!
  end

  def addons_client! cmd
    stub(Settings).rest { cmd.split }
    Addons::CLI.run!
  end
end
