# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluent/tranquility/version'

Gem::Specification.new do |spec|
  spec.name          = 'fluent-tranquility'
  spec.version       = Fluent::Tranquility::VERSION
  spec.authors       = ['Marcelo Wiermann']
  spec.email         = ['marcelo.wiermann@gmail.com']
  spec.summary       = 'Druid Tranquility Fluentd Output Plugin'
  spec.description   = 'Druid Tranquility Fluentd Output Plugin'
  spec.license       = 'MIT'
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }

  spec.add_runtime_dependency 'faraday', '~> 0.10'
  spec.add_runtime_dependency 'fluentd', '~> 0.12'
  spec.add_runtime_dependency 'net-http-persistent', ['>= 2.9', '< 3']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
end
