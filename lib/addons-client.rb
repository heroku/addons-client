$LOAD_PATH.unshift File.dirname(File.expand_path('..', __FILE__)) + '/lib'

require "addons-client/version"
require 'rest-client'
require 'digest'
require 'configliere'

module Addons
  module Client
    Exception = Class.new(Exception)
    UserError = Class.new(RuntimeError)
  end
end

require 'addons-client/cli'
