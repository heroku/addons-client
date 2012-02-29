require_relative 'test_helper'

class SettingsTest < Addons::Client::TestCase
  def setup
    stub_request(:any, /api\/1\/resources/)
    ENV['ADDONS_API_URL'] = 'https://test:password@localhost:3333' 
    @client = Addons::Client.new
  end

  def test_client_uses_env_var
    @client.provision! 'foo:bar'
    assert_requested(:post, URI.join(ENV['ADDONS_API_URL'], '/api/1/resources').to_s)
  end

  def test_client_raises_error_on_bad_url
    [
      nil, 
     'https://localhost:3333',
     'https://foo@localhost:3333',
    ].each do |url|
      ENV['ADDONS_API_URL'] = url
      assert_raises Addons::UserError do
        Addons::Client.new 
      end
    end
  end

  def test_client_handles_404s_gracefully
    stub_request(:any, /api\/1\/resources/).to_return(:status => 404)
    assert_raises Addons::UserError do
      @client.provision! 'foo:bar'
    end 
  end
end
