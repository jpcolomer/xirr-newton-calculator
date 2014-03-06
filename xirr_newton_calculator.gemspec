SPEC = Gem::Specification.new do |s|
  s.name        = 'xirr_newton_calculator'
  s.version     = '0.0.8'
  s.date        = '2013-10-17'
  s.author      = "JP Colomer"
  s.email       = 'jpcolomer@gmail.com'
	s.summary     = "a library to calculate xirr on Ruby."
  s.files       = ["lib/xirr_newton_calculator.rb", "spec/xirr_newton_calculator_spec.rb", "README.md"]
  s.homepage    = %q{https://github.com/jpcolomer/xirr-newton-calculator}

  s.required_ruby_version = '>=1.9'
	s.add_development_dependency 'rspec', '>= 2.14.1'	
  s.license       = 'MIT'
end
