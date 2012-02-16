
require_relative 'test_helper'

class MockModeTest < Addons::Client::TestCase

  def setup
    Addons::Client.mock!
    @client = Addons::Client.new
  end

  def teardown
    super
    Addons::Client.unmock!
  end

  def test_provision_mock
    @client.provision! 'memcache:5mb' 
  end
end
