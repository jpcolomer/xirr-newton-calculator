SPEC = Gem::Specification.new do |s|
  s.name        = 'Xirr Newton Calculator'
  s.version     = '0.0.1'
  s.date        = '2013-10-17'
  s.author     = "JP Colomer"
  s.email       = 'jpcolomer@gmail.com'
	s.summary = "a library to calculate xirr on Ruby."
  s.files       = Filelist["lib/**/*.rb", "spec/**/*.rb", "README.md"].to_a

  s.required_ruby_version = '>=1.9'
	s.add_development_dependency 'rspec', '>= 2.14.1'	
  s.license       = 'MIT'
end