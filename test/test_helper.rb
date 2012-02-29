require 'test/unit'
Bundler.require :test
require 'webmock/test_unit'
require_relative '../lib/addons-client'

class Addons::Client::TestCase < Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def setup
  end

  def resource_url
    URI.join(ENV["ADDONS_API_URL"], '/api/1/resources/', 'addons-uuid').to_s
  end

  def teardown
    WebMock.reset!
    ::ARGV.replace []
    Settings.replace Hash.new
  end

  def addons_client! cmd
    ::ARGV.replace cmd.split
    Addons::CLI.run!
  end
end
