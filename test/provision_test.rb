require_relative 'test_helper'

class ProvisionTest < Addons::Client::TestCase
  def setup
    ENV["ADDONS_API_URL"] = 'https://foo:bar@heroku.com/api/1/resources'
    stub_request(:any, target_url)
    stub(Addons::CLI).puts
    @client = Addons::Client.new
  end

  def target_url
    ENV["ADDONS_API_URL"]
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

  def test_client_sets_provision_options
    @client.provision! 'foo:bar', 
      :consumer_id => 'app123@heroku.com',
      :options => { :foo => 'bar', 'baz' => 'test' } 

    assert_requested(:post, target_url,
      body: { addon: 'foo', plan: 'bar', 
        consumer_id: 'app123@heroku.com',
        options: { foo: 'bar', baz: 'test'}})
  end

  def test_cmd_line_sets_provision_options
    addons_client! "provision foo:bar --options.foo=bar --options.baz=test --consumer_id=app123@heroku.com"

    assert_requested(:post, target_url,
      body: { addon: 'foo', plan: 'bar', 
        consumer_id: 'app123@heroku.com',
        options: { foo: 'bar', baz: 'test'}})
    assert_received(Addons::CLI) do |cli| 
      cli.puts "Provisioned foo:bar"
    end
  end
end
