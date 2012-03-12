require 'test/unit'
Bundler.require :test
require 'webmock/test_unit'
require "#{File.dirname(__FILE__)}/../lib/addons-client"

class Addons::Client::TestCase < Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def setup
    super
  end

  def resource_url
    URI.join(ENV["ADDONS_API_URL"], '/api/1/resources/', 'addons-uuid').to_s
  end

  def teardown
    super
    WebMock.reset!
    ::ARGV.replace []
    Settings.replace Hash.new
  end

  def addons_client! cmd
    ::ARGV.replace cmd.split
    Addons::CLI.run!
  end

  # for ruby 1.8.7 Test::Unit compatibility
  def default_test
  end
end
