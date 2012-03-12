require "#{File.dirname(__FILE__)}/test_helper"

class DeprovisionTest < Addons::Client::TestCase
  def setup
    ENV["ADDONS_API_URL"] = 'https://foo:bar@heroku.com'
    stub_request(:any, target_url).to_return :body => " "
    stub(Addons::CLI).puts
  end

  alias :target_url :resource_url

  def test_cmd_line_requires_resource_id
    assert_raises Addons::UserError, "Must supply resource id" do
      addons_client! "deprovision"
    end
  end

  def test_deprovisions_from_cmd_line
    addons_client! "deprovision addons-uuid"
    assert_requested(:delete, target_url)
  end

  def test_deprovisions_from_ruby
    Addons::Client.deprovision! "addons-uuid"
    assert_requested(:delete, target_url)
  end
end
