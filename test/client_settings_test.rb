require_relative 'test_helper'

class SettingsTest < Addons::Client::TestCase
  def test_requires_api_salt
    assert_raises Addons::Client::UserError do 
      Addons::Client::CLI.run!
    end
  end
end
