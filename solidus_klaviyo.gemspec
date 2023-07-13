# frozen_string_literal: true

require_relative 'lib/solidus_klaviyo/version'

Gem::Specification.new do |spec|
  spec.name = 'solidus_klaviyo'
  spec.version = SolidusKlaviyo::VERSION
  spec.authors = ['Alessandro Desantis']
  spec.email = 'desa.alessandro@gmail.com'

  spec.summary = 'Klaviyo integration for Solidus stores.'
  spec.homepage = 'https://github.com/solidusio-contrib/solidus_klaviyo'
  spec.license = 'BSD-3-Clause'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/solidusio-contrib/solidus_klaviyo'
  spec.metadata['changelog_uri'] = 'https://github.com/solidusio-contrib/solidus_klaviyo/releases'

  spec.required_ruby_version = Gem::Requirement.new('>= 2.5')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  spec.files = files.grep_v(%r{^(test|spec|features)/})
  spec.test_files = files.grep(%r{^(test|spec|features)/})
  spec.bindir = "exe"
  spec.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'solidus_core', '>= 2.0.0'
  spec.add_dependency 'solidus_support', '~> 0.8'

  spec.add_dependency 'httparty', '~> 0.18'
  spec.add_dependency 'klaviyo-api-sdk', '~> 3.0'
  spec.add_dependency 'solidus_tracking'

  spec.add_development_dependency 'solidus_dev_support'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
