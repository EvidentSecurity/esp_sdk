# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'esp_sdk/version'

Gem::Specification.new do |spec|
  spec.name          = 'ESP SDK'
  spec.version       = EspSdk::VERSION
  spec.authors       = ['Andrew Medeiros']
  spec.email         = ['amedeiros0920@gmail.com']
  spec.summary       = %q{SDK for interacting with the ESP API.}
  spec.homepage      = ""
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'

  spec.add_runtime_dependency 'activesupport'
end
