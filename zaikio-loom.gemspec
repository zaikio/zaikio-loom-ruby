lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "zaikio/loom/version"

Gem::Specification.new do |spec|
  spec.name     = "zaikio-loom"
  spec.version  = Zaikio::Loom::VERSION

  spec.authors  = ["crispymtn", "Martin Spickermann"]
  spec.email    = ["op@crispymtn.com", "spickermann@gmail.com"]
  spec.homepage = "https://github.com/zaikio/zai-loom-ruby"
  spec.license  = "MIT"
  spec.summary  = "The Zaikio Loom Ruby Gem simplifies publishing events on the Zaikio Loom event system."

  spec.metadata["changelog_uri"] = "https://github.com/zaikio/zai-loom-ruby/blob/master/CHANGELOG.md"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", ">= 1.11.0"
  spec.add_dependency "rails", "~> 6.0", ">= 6.0.2.3"
  spec.add_runtime_dependency "oj"
  spec.required_ruby_version = ">= 2.7.1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-minitest"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "webmock"
end
