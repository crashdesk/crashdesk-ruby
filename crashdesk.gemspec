# -*- encoding: utf-8 -*-
require File.expand_path('../lib/crashdesk/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = 'crashdesk'
  gem.version = Crashdesk::VERSION
  gem.authors = ["Ladislav Martincik"]
  gem.summary = "Crashde.sk is helping you track crashes of your application online"
  gem.description = "crashdesk is the Ruby gem for containing core functionality for communication with crashde.sk servers"
  gem.email = "info@crashde.sk"
  gem.files =  Dir['lib/**/*'] + Dir['spec/**/*'] + Dir['*.rb'] + ["crashdesk.gemspec"]
  gem.homepage = "http://crashde.sk"
  gem.require_paths = ["lib"]
  gem.rubyforge_project = "crashdesk"
  gem.requirements << "json_pure, json-jruby or json gem required"
end
