# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'esp_sdk/version'

Gem::Specification.new do |spec|
  spec.name          = 'esp_sdk'
  spec.version       = EspSdk::VERSION
  spec.authors       = ['Evident.io']
  spec.email         = ['support@evident.io']
  spec.summary       = %q{SDK for interacting with the ESP API.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.3.2'
  spec.add_development_dependency 'rubocop', '~> 0.27.1'
  spec.add_development_dependency 'minitest', '~> 5.4.2'
  spec.add_development_dependency 'minitest-reporters', '~> 1.0.7'
  spec.add_development_dependency 'shoulda', '~> 3.5.0'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.4.1'
  spec.add_development_dependency 'mocha', '~> 1.1.0'
  spec.add_development_dependency 'fakeweb', '~> 1.3'

  spec.add_runtime_dependency 'activesupport', '~> 4.1.6'
  spec.add_runtime_dependency 'rest_client', '~> 1.7.3'
  spec.add_runtime_dependency 'pry', '~> 0.10.1'
  spec.add_runtime_dependency 'awesome_print', '~> 1.2.0'
  spec.add_runtime_dependency 'artii', '~> 2.1.1'
end
