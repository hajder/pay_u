$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pay_u/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pay_u"
  s.version     = PayU::VERSION
  s.authors     = ["Michał Szyndel"]
  s.email       = ["szyndel@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of PayU."
  s.description = "TODO: Description of PayU."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"
  s.add_dependency "i18n"
  s.add_dependency "sucker_punch"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry"
end
