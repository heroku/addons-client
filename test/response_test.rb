require "#{File.dirname(__FILE__)}/test_helper"

# testing the canned responses with the mocks
# means we are both testing the mock mode and
# keeping the mocked responses in one place
class ResponseTest < Addons::Client::TestCase
  def setup
    super
    Addons::Client.mock!
  end

  def teardown
    super
    Addons::Client.unmock!
  end

  def target_url
    URI.join(ENV["ADDONS_API_URL"], '/api/1/resources').to_s
  end

  def test_response_parses_json
    Addons::Client.unmock!
    stub_request(:any, target_url).to_return(:body => {
      'resource_id' => '123-ABC',
      'config' => {'ADDON_URL' => 'foo'},
      'message' => 'great success',
      'provider_id' => '42'
    }.to_json)

    response = Addons::Client.provision! 'memcache:5mb'

    assert_equal '123-ABC', response.resource_id
    assert_equal 'foo', response.config['ADDON_URL']
    assert_equal 'great success', response.message
    assert_equal '42', response.provider_id
  end

  def test_response_object_wraps_provision_data
    response = Addons::Client.provision! 'memcache:5mb'

    assert_equal 'DEADBEEF', response.resource_id
    assert_equal 'http://foo.com', response.config['MEMCACHE_URL']
    assert_equal 'great success', response.message
    assert_equal 'ABC123', response.provider_id
  end

  def test_response_object_wraps_deprovision
    response = Addons::Client.deprovision! 'UUID'
  end

  def test_response_object_wraps_plan_change
    response = Addons::Client.plan_change! 'UUID', 'plan'
  end
end

