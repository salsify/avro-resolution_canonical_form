# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'avro/resolution_canonical_form/version'

Gem::Specification.new do |spec|
  spec.name          = 'avro-resolution_canonical_form'
  spec.version       = Avro::ResolutionCanonicalForm::VERSION
  spec.authors       = ['Salsify, Inc']
  spec.email         = ['engineering@salsify.com']

  spec.summary       = 'Unique identification of Avro schemas for schema resolution'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/salsify/avro-resolution_canonical_form'

  spec.license       = 'MIT'

  # Set 'allowed_push_post' to control where this gem can be published.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'salsify_rubocop', '~> 0.46.0'
  spec.add_development_dependency 'overcommit'
  spec.add_development_dependency 'simplecov'
  spec.add_runtime_dependency 'avro-salsify-fork', '>= 1.9.0.5'
end
