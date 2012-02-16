require_relative 'test_helper'

# eating our own dogfood and keeping mocked responses
# DRY and sharable
class ResponseTest < Addons::Client::TestCase
  def setup
    Addons::Client.mock!
    @client = Addons::Client.new
  end

  def teardown
    Addons::Client.unmock!
  end

  def test_response_object_wraps_provision_data
    response = @client.provision! 'memcache:5mb'

    assert_equal 'DEADBEEF', response.resource_id
    assert_equal 'http://foo.com', response.config['MEMCACHE_URL']
    assert_equal 'great success', response.message
    assert_equal 'ABC123', response.provider_id
  end
end

