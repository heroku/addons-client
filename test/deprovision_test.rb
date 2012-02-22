require_relative 'test_helper'

class DeprovisionTest < Addons::Client::TestCase
  def setup
    ENV["ADDONS_API_URL"] = 'https://foo:bar@heroku.com/api/1/resources'
    stub_request(:any, target_url)
    stub(Addons::CLI).puts
    @client = Addons::Client.new
  end

  def target_url
    ENV["ADDONS_API_URL"] + '/addons-uuid'
  end

  def test_deprovisions_from_cmd_line
    addons_client! "deprovision addons-uuid"
    assert_requested(:delete, target_url)
  end

  def test_deprovisions_from_ruby
    @client.deprovision! "addons-uuid"
    assert_requested(:delete, target_url)
  end
end
