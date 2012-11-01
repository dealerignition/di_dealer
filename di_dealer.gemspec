$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "di_dealer"
  s.version     = "0.0.1"
  s.authors     = ["Dealer Ignition"]
  s.email       = ["support@dealerignition.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Dealer."
  s.description = "TODO: Description of Dealer."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "nestful"

  s.add_development_dependency "sqlite3"

  s.add_development_dependency "rspec"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "webmock"
  s.add_development_dependency "guard"
  s.add_development_dependency "rb-inotify"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "simplecov"
end
