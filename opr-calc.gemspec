Gem::Specification.new do |s|
	s.name        = 'opr-calc'
	s.email       = 'kristofer.rye@gmail.com'
	s.version     = '0.1.3'

	s.summary     = 'A tool for calculating OPR and other scouting stats for FRC teams.'
	s.description = "A tool for calculating the OPR, DPR, and CCWM of FRC teams, allowing for more detailed analysis of a team's projected performance.  Uses the internal Ruby Matrix library for basic Matrix operations."

	s.authors     = ['Kristofer Rye',
	                 'Christopher Cooper',
	                 'Sam Craig']

	s.homepage    = 'https://github.com/frc461/opr-calc'
	s.files       = Dir['lib/**/*.rb'] + %W[Gemfile opr-calc.gemspec LICENSE README.md Rakefile]
	s.test_files  = Dir['test/**/*.rb']
	s.required_ruby_version = '>= 1.9.3'
	s.license     = 'GPL-3.0'

	s.add_development_dependency 'minitest', '~> 5.2'
	s.add_development_dependency 'rake', '~> 11'
end
