Gem::Specification.new do |spec|
  spec.name          = "lita-releaser"
  spec.version       = "0.0.1"
  spec.authors       = ["Josh Rendek"]
  spec.email         = ["josh@bluescripts.net"]
  spec.homepage      = "https://github.com/joshrendek/lita-releaser.git"
  spec.description   = %q{Interact with Github and pull requests to release}
  spec.summary       = %q{Interact with Github and pull requests to release}
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.1"

  spec.add_runtime_dependency "lita", ">= 3.0"
  spec.add_runtime_dependency "octokit", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0.beta2"
end
