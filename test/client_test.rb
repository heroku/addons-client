require_relative 'test_helper'

describe Addons::Client do
  before do
    @client = Addons::Client.new(:username => 'test',
                                 :password => 'pass',
                                 :salt     => 'salt') 
  end

  it "defaults to https" do
    @client.resource.url.must_match /^https:/
  end

  it "should allow you to set the scheme" do
    @client.scheme = 'http'
    @client.resource.url.must_match /^http:/
  end
end
