require "#{File.dirname(__FILE__)}/test_helper"

class ProvisionTest < Addons::Client::TestCase
  def setup
    ENV["ADDONS_API_URL"] = 'https://foo:bar@heroku.com'
    stub_request(:any, target_url)
    stub(Addons::CLI).puts
  end

  def target_url
    URI.join(ENV["ADDONS_API_URL"], '/api/1/resources').to_s
  end

  def test_cmd_line_requires_addon_slug
    assert_raises Addons::UserError, "Must supply addon:plan" do
      addons_client! "provision"
    end
  end

  def test_cmd_line_doesnt_require_plan
    addons_client! "provision foo"
    assert_requested(:post, target_url,
      :body => { :addon => 'foo',
        :consumer_id => 'api-client@localhost'})
  end

  def test_provisions_from_cmd_line
    addons_client! "provision memcache:5mb"
    assert_requested(:post, target_url,
      :body => { :addon => 'memcache', :plan => '5mb',
              :consumer_id => 'api-client@localhost'})
  end

  def test_provisions_from_ruby
    Addons::Client.provision! 'foo:plizzan'
    assert_requested(:post, target_url,
      :body => { :addon => 'foo', :plan => 'plizzan',
        :consumer_id => 'api-client@localhost'})
  end

  def test_sets_consumer_id
    Addons::Client.provision! 'foo:bar', :consumer_id => 'app123@heroku.com'
    assert_requested(:post, target_url,
      :body => { :addon => 'foo', :plan => 'bar',
        :consumer_id => 'app123@heroku.com'})
  end

  def test_client_sets_provision_options
    Addons::Client.provision! 'foo:bar',
      :consumer_id => 'app123@heroku.com',
      :options => { :foo => 'bar', 'baz' => 'test' }

    assert_requested(:post, target_url,
      :body => { :addon => 'foo', :plan => 'bar',
        :consumer_id => 'app123@heroku.com',
        :options => { :foo => 'bar', :baz => 'test'}})
  end

  def test_cmd_line_sets_provision_options
    addons_client! "provision foo:bar --options.foo=bar --options.baz=test --consumer_id=app123@heroku.com"

    assert_requested(:post, target_url,
      :body => { :addon => 'foo', :plan => 'bar',
        :consumer_id => 'app123@heroku.com',
        :options => { :foo => 'bar', :baz => 'test'}})
    assert_received(Addons::CLI) do |cli|
      cli.puts "Provisioned foo:bar"
    end
  end
end
