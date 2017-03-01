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
  s.summary     = "This gem parses your Amex data files into human readable data."
  s.description = "This gem is a parser for American Express transaction reconciliation files."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_development_dependency "rspec", "~> 2.12"
  s.add_development_dependency "rake", "~> 10.0"
end
