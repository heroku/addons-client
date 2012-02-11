require_relative 'test_helper'

class ProvisionTest < Addons::Client::TestCase
  def setup
    super
    stub_request(:any, target_url)
    @client = Addons::Client.new(:username => 'test',
                                 :password => 'pass',
                                 :salt     => 'salt') 
  end

  def target_url
    /resources$/
  end

  def test_provisions_from_cmd_line
    addons_client! "provision memcache:5mb"
    assert_requested(:post, target_url,
      body: { addon: 'memcache', plan: '5mb', 
              consumer_id: 'api-client@localhost'})
  end

  def test_provisions_from_ruby
    @client.provision! 'foo:plizzan'
    assert_requested(:post, target_url,
      body: { addon: 'foo', plan: 'plizzan', 
        consumer_id: 'api-client@localhost'})
  end

  def test_sets_consumer_id
    @client.provision! 'foo:bar', :consumer_id => 'app123@heroku.com'
    assert_requested(:post, target_url,
      body: { addon: 'foo', plan: 'bar', 
        consumer_id: 'app123@heroku.com'})
  end

  def test_sets_scheme
  end

  def test_accepts_options
  end
end
