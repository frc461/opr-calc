Gem::Specification.new do |s|
	s.name        = "opr-calc"
	s.version     = "0.1.0"
	s.summary     = "A tool for calculating OPR and other scouting stats for FRC teams."
	s.authors     = ["Kristofer Rye", "Christopher Cooper", "Sam Craig"]
	s.homepage    = "https://github.com/team461WBI/opr-calc"
	s.files       = ["lib/opr-calc.rb"] + Dir.glob("lib/**/*.rb")
	s.required_ruby_version = ">= 1.9.3"
	s.license     = "GPL-3.0"

	s.add_development_dependency "minitest"
	s.add_development_dependency "rake"
end
