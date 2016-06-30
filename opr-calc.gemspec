Gem::Specification.new do |s|
	s.name        = 'opr-calc'
	s.email       = 'kristofer.rye@gmail.com'
	s.version     = '0.1.3'

	s.summary     = 'A tool for calculating OPR and other scouting stats for FRC teams.'
	s.description = 'A tool for calculating OPR and other scouting stats for FRC teams on either a competitionly or seasonly basis.'

	s.authors     = ['Kristofer Rye',
	                 'Christopher Cooper',
	                 'Sam Craig']

	s.homepage    = 'https://github.com/frc461/opr-calc'
	s.files       = ['lib/opr-calc.rb'] + Dir.glob('lib/**/*.rb')
	s.required_ruby_version = '>= 1.9.3'
	s.license     = 'GPL-3.0'

	s.add_development_dependency 'minitest', '~> 5.2'
	s.add_development_dependency 'rake', '~> 11'
end
