Gem::Specification.new do |s|
	s.name        = "opr-calc"
	s.email       = "kristofer.rye@gmail.com"
	s.version     = "0.1.3"

	s.summary     = "A tool for calculating OPR and other scouting stats for FRC teams."
	s.description = "A tool for calculating OPR and other scouting stats for FRC teams on either a competitionly or seasonly basis."

	s.authors     = ["Christopher Cooper",
	                 "Sam Craig",
	                 "Kristofer Rye"]

	s.homepage    = "https://github.com/team461WBI/opr-calc"
	s.files       = ["lib/opr-calc.rb"] + Dir.glob("lib/**/*.rb")
	s.required_ruby_version = ">= 1.9.3"
	s.license     = "GPL-3.0"

	s.add_development_dependency "minitest", "~> 5.2"
	s.add_development_dependency "rake", "~> 10.1"
end
