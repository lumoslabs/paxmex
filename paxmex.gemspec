$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "paxmex/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "paxmex"
  s.version     = Paxmex::VERSION
  s.authors     = ["Daryl Yeo", "Anthony Zacharakis"]
  s.email       = ["daryl@lumoslabs.com"]
  s.homepage    = "https://github.com/lumoslabs/paxmex"
  s.summary     = "This gem parses your Amex data files into human readable data.."
  s.description = "TODO: Description."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.12"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
