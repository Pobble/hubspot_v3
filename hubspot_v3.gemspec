# frozen_string_literal: true

require_relative "lib/hubspot_v3/version"

Gem::Specification.new do |spec|
  spec.name          = "hubspot_v3"
  spec.version       = HubspotV3::VERSION
  spec.authors       = ["Tomas Valent"]
  spec.email         = ["tomas.valent@gmail.com"]

  spec.summary       = "Hubspot CRM API (v3) Ruby gem"
  spec.description   = "Ruby wrapper around Hubspot CRM API v3 with simple implementation around batch endpoints and private apps token support"
  spec.homepage      = "https://github.com/Pobble/hubspot_v3"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Pobble/hubspot_v3"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "httparty", "~> 0.2"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
