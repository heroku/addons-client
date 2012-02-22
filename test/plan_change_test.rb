require_relative 'test_helper'

class PlanChangeTest < Addons::Client::TestCase
  def setup
    ENV["ADDONS_API_URL"] = 'https://foo:bar@heroku.com/api/1/resources'
    stub_request(:any, target_url)
    stub(Addons::CLI).puts
    @client = Addons::Client.new
  end

  def target_url
    ENV["ADDONS_API_URL"] + '/addons-uuid'
  end

  def test_plan_change_from_cmd_line
    addons_client! "plan_change addons-uuid memcache:5mb"
    assert_requested(:put, target_url,
      body: { addon: 'memcache', plan: '5mb',
              consumer_id: 'api-client@localhost'})
  end

  def test_plan_change_from_ruby
    @client.plan_change! 'addons-uuid', 'foo:plizzan'
    assert_requested(:put, target_url,
      body: { addon: 'foo', plan: 'plizzan',
        consumer_id: 'api-client@localhost'})
  end

  def test_client_sets_plan_change_options
    @client.plan_change! 'addons-uuid', 'foo:bar',
      :consumer_id => 'app123@heroku.com',
      :options => { :foo => 'bar', 'baz' => 'test' }

    assert_requested(:put, target_url,
      body: { addon: 'foo', plan: 'bar',
        consumer_id: 'app123@heroku.com',
        options: { foo: 'bar', baz: 'test'}})
  end

  def test_cmd_line_sets_plan_change_options
    addons_client! "plan_change addons-uuid foo:bar --options.foo=bar --options.baz=test --consumer_id=app123@heroku.com"

    assert_requested(:put, target_url,
      body: { addon: 'foo', plan: 'bar',
        consumer_id: 'app123@heroku.com',
        options: { foo: 'bar', baz: 'test'}})
    assert_received(Addons::CLI) do |cli|
      cli.puts "Plan Changed to foo:bar"
    end
  end
end
