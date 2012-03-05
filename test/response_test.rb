require_relative 'test_helper'

# testing the canned responses with the mocks
# means we are both testing the mock mode and
# keeping the mocked responses in one place
class ResponseTest < Addons::Client::TestCase
  def setup
    Addons::Client.mock!
  end

  def teardown
    Addons::Client.unmock!
  end

  def test_response_object_wraps_provision_data
    response = Addons::Client.provision! 'memcache:5mb'

    assert_equal 'DEADBEEF', response.resource_id
    assert_equal 'http://foo.com', response.config['MEMCACHE_URL']
    assert_equal 'great success', response.message
    assert_equal 'ABC123', response.provider_id
  end
end

