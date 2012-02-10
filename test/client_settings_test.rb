require_relative 'test_helper'

class SettingsTest < Addons::Client::TestCase
  def test_requires_api_salt_and_api_password
    assert_raises Addons::UserError do 
      Addons::Client::CLI.run!
    end

    ENV['ADDONS_API_SALT'] = 'salt'
    ENV['ADDONS_API_PASSWORD'] = 'bacon'
    assert_nothing_raised { Addons::Client::CLI.run! }
  end
end
