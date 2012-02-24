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
    addons_client! "plan-change addons-uuid 5mb"
    assert_requested(:put, target_url,
      body: { plan: '5mb' })
  end

  def test_plan_change_from_ruby
    @client.plan_change! 'addons-uuid', 'plizzan'
    assert_requested(:put, target_url,
      body: {  plan: 'plizzan' })
  end

  def test_client_sets_plan_change_options
    @client.plan_change! 'addons-uuid', 'bar'

    assert_requested(:put, target_url,
      body: { plan: 'bar' })
  end

  def test_cmd_line_sets_plan_change_options
    addons_client! "plan-change addons-uuid bar"

    assert_requested(:put, target_url,
      body: { plan: 'bar' })
    assert_received(Addons::CLI) do |cli|
      cli.puts "Plan Changed to bar"
    end
  end
end
