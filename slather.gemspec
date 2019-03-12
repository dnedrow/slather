lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slather/version'

Gem::Specification.new do |spec|
  spec.name          = 'slather'
  spec.version       = Slather::VERSION
  spec.authors       = ['Mark Larsen']
  spec.email         = ['mark@venmo.com']
  spec.summary       = 'Configurable coverage reports for Xcode projects.'
  spec.homepage      = 'https://github.com/SlatherOrg/slather'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0', '>= 2.0.1'
  spec.add_development_dependency 'cocoapods', '~> 1.6', '>= 1.6.1'
  spec.add_development_dependency 'coveralls', '~> 0.8.22'
  spec.add_development_dependency 'equivalent-xml', '~> 0.6.0'
  spec.add_development_dependency 'json_spec', '~> 1.1', '>= 1.1.5'
  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'rake', '~> 12.3', '>= 12.3.2'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'

  spec.add_dependency 'CFPropertyList', '~> 3.0'
  spec.add_dependency 'clamp', '~> 1.3'
  spec.add_dependency 'nokogiri', '~> 1.10', '>= 1.10.1'
  spec.add_dependency 'xcodeproj', '~> 1.8', '>= 1.8.1'

  spec.add_runtime_dependency 'activesupport', '~> 4.2', '>= 4.2.11'
end
