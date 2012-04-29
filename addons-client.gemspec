# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.dirname(File.expand_path('.', __FILE__)) + '/lib'
require "addons-client/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Chris Continanza"]
  gem.email         = ["csquared@gmail.com"]
  gem.description   = %q{Addons Platform API client}
  gem.summary       = %q{Allows platfomrs to provision, deprovision, and change plans for add-on resources.}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "addons-client"
  gem.require_paths = ["lib"]
  gem.version       = Addons::Client::VERSION

  gem.add_dependency 'rest-client'
  gem.add_dependency 'configliere'
  gem.add_dependency 'json'
end
