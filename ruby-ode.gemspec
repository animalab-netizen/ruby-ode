Gem::Specification.new do |spec|
  spec.name = "ruby-ode"
  spec.version = "0.1.0"
  spec.authors = ["ÂnimaLab"]
  spec.email = ["animalab.desenvolvimento@gmail.com"]
  spec.summary = "Opinionated delivery engine for Ruby applications."
  spec.description = "Ruby runtime for direct, chain, sequence and guard-oriented ODE flows."
  spec.homepage = "https://github.com/animalab-netizen/ruby-ode"
  spec.license = "Apache-2.0"
  spec.metadata = {
    "homepage_uri" => "https://github.com/animalab-netizen/ruby-ode",
    "source_code_uri" => "https://github.com/animalab-netizen/ruby-ode",
    "changelog_uri" => "https://github.com/animalab-netizen/ruby-ode/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://github.com/animalab-netizen/ruby-ode/blob/main/README.md",
    "bug_tracker_uri" => "https://github.com/animalab-netizen/ruby-ode/issues"
  }
  spec.files = Dir["lib/**/*.rb"] + %w[README.md CHANGELOG.md CONTRIBUTING.md PUBLICATION.md USECASE_GUIDE.md]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3.2"
end
