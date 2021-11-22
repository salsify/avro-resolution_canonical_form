# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'avro-resolution_canonical_form/version'

Gem::Specification.new do |spec|
  spec.name          = 'avro-resolution_canonical_form'
  spec.version       = AvroResolutionCanonicalForm::VERSION
  spec.authors       = ['Salsify, Inc']
  spec.email         = ['engineering@salsify.com']

  spec.summary       = 'Unique identification of Avro schemas for schema resolution'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/salsify/avro-resolution_canonical_form'

  spec.license       = 'MIT'

  # Set 'allowed_push_post' to control where this gem can be published.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
    spec.metadata['rubygems_mfa_required'] = 'true'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'overcommit'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'salsify_rubocop', '~> 1.0.1'
  spec.add_development_dependency 'simplecov'

  spec.add_runtime_dependency 'avro', '~> 1.11.0'

  spec.post_install_message = %(
avro-resolution_canonical_form now requires Avro v1.11.

Avro Ruby v1.11 adds support for decimal logical type attributes on fixed types and these attributes are
included in the resolution canonical form.

Schemas that use these attributes will get a different fingerprint with
this version. For projects that only use Ruby, use of these features is unlikely
as they were previously unsupported, and encoding/decoding fixed decimals is not yet supported.
)
end
