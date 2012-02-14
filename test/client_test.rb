require_relative 'test_helper'

class SettingsTest < Addons::Client::TestCase
  def setup
    super
    stub_request(:any, /api\/1\//)
  end

  def test_works_when_options_provided
    assert_nothing_raised { Addons::CLI.run! }
  end

  def test_hashes_password
    password = Digest::SHA1.hexdigest('salt:bacon') 
    addons_client! "provision memcache:5mb"
    assert_requested :post, /heroku:#{password}/
  end

  def test_client_sets_username_password_and_salt
    password = Digest::SHA1.hexdigest('salt:pass') 
    client = Addons::Client.new(:username => 'test',
                                :password => 'pass',
                                :salt     => 'salt') 
    client.provision! 'foo:bar'
    target_url = "https://test:#{password}@localhost:3000/api/1/resources"
    assert_requested(:post, target_url)
  end

  def test_requires_api_password
    Settings.delete :api_password
    ENV['ADDONS_API_PASSWORD'] = nil
    assert_raises Addons::UserError do 
      addons_client! "provision memcache:5mb"
    end
  end

  def test_requires_api_salt
    Settings.delete :api_salt
    ENV['ADDONS_API_SALT'] = nil
    assert_raises Addons::UserError do 
      addons_client! "provision memcache:5mb"
    end
  end

  def test_sets_password_and_salt_from_cmd_line
    Settings.delete :api_password
    ENV['ADDONS_API_PASSWORD'] = nil
    Settings.delete :api_salt
    ENV['ADDONS_API_SALT'] = nil
    assert_nothing_raised do
      addons_client! "provision memcache:5mb --api_password=pass --api_salt=salt"
    end
  end

  def test_reads_url_from_env

  end
end
