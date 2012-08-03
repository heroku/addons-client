require "#{File.dirname(__FILE__)}/test_helper"

class ListTest < Addons::Client::TestCase
  def setup
    ENV["ADDONS_API_URL"] = 'https://addons.heroku.com'
    stub_request(:get, %r{#{target_url}}).to_return(:body => [
      {"id" => "https://addons.heroku.com/addons/cloudcounter:basic","url" => "https://addons.heroku.com/addons/cloudcounter:basic","name" => "cloudcounter:basic","description" => "The basic counter of clouds","beta" => false,"state" => "public","price_cents" => 0,"price_unit" => "month"},
      {"id" => "https://addons.heroku.com/addons/cloudcounter:pro","url" => "https://addons.heroku.com/addons/cloudcounter:pro","name" => "cloudcounter:pro","description" => "The counter of clouds for professionals","beta" => false,"state" => "public","price_cents" => 1500,"price_unit" => "month"}].
    to_json)
    stub(Addons::CLI).puts
  end

  def target_url
    URI.join(ENV["ADDONS_API_URL"], '/api/1/addons').to_s
  end

  def test_cmd_line_lists_addons
    addons_client! "list"
    assert_requested(:get, target_url)
    assert_received(Addons::CLI) do |cli|
      cli.puts "cloudcounter:basic $0.00/month"
      #cli.puts "cloudcounter:pro $15.00/month"
    end
  end

  def test_cmd_line_passes_arguments
    addons_client! "list cloud thing"
    assert_requested(:get, target_url + "?search=cloud+thing")
  end

  def test_lists_from_ruby
    Addons::Client.list
    assert_requested(:get, target_url)
  end

  def test_passes_args_from_ruby
    Addons::Client.list "cloud thing"
    assert_requested(:get, target_url + "?search=cloud+thing")
  end

end

