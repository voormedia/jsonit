# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jsonit/version"

Gem::Specification.new do |s|
  s.name        = "jsonit"
  s.version     = Jsonit::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Klaas Speller"]
  s.email       = ["k.speller@voormedia.com"]
  s.homepage    = ""
  s.summary     = %q{A JSON templating language}
  s.description = %q{Create JSON documents with ease}

  s.rubyforge_project = "jsonit"

  s.add_development_dependency "json"
  s.add_development_dependency "tilt"
  s.add_development_dependency "rspec"
  s.add_development_dependency "mocha"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
