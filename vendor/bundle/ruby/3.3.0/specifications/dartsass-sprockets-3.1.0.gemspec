# -*- encoding: utf-8 -*-
# stub: dartsass-sprockets 3.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "dartsass-sprockets".freeze
  s.version = "3.1.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ryan Boland".freeze, "Johnny Shields".freeze]
  s.date = "2023-12-31"
  s.description = "Use Dart Sass with Sprockets and the Ruby on Rails asset pipeline.".freeze
  s.email = ["ryan@tanookilabs.com".freeze]
  s.homepage = "https://github.com/tablecheck/dartsass-sprockets".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.1".freeze)
  s.rubygems_version = "3.5.3".freeze
  s.summary = "Use Dart Sass with Sprockets and the Ruby on Rails asset pipeline.".freeze

  s.installed_by_version = "3.5.3".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<railties>.freeze, [">= 4.0.0".freeze])
  s.add_runtime_dependency(%q<sassc-embedded>.freeze, ["~> 1.69".freeze])
  s.add_runtime_dependency(%q<sprockets>.freeze, ["> 3.0".freeze])
  s.add_runtime_dependency(%q<sprockets-rails>.freeze, [">= 0".freeze])
  s.add_runtime_dependency(%q<tilt>.freeze, [">= 0".freeze])
end
