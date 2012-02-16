require_relative 'test_helper'

class ResponseTest < Addons::Client::TestCase
  def setup
    ENV["ADDONS_API_URL"] = 'https://foo:bar@heroku.com/api/1/resources'
    @client = Addons::Client.new

    stub_request(:any, ENV['ADDONS_API_URL']).
      to_return(status: 201, body: {
        resource_id: "DEADBEEF",
        config: {"MYADDON_URL" => 'http://foo.com'},
        message: "great success",
        provider_id: 1234
      })
  end


  def test_response_object_wraps_provision_data
    response = @client.provision! 'memcache:5mb'

    assert_equal 'DEADBEEF', response.resource_id
    assert_equal 'http://foo.com', response.config['MYADDON_URL']
    assert_equal 'great success', response.message
    assert_equal 1234, response.provider_id
  end
end

