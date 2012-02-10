$LOAD_PATH.unshift File.dirname(File.expand_path('..', __FILE__)) + '/lib'

require "addons-client/version"
require 'rest-client'
require 'digest'
require 'configliere'

module Addons
  Exception = Class.new(Exception)
  UserError = Class.new(RuntimeError)
end

require 'addons-client/client'
require 'addons-client/cli'
