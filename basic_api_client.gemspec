files = ['lib/basic_api_client.rb', 'LICENSE', 'README.md']

Gem::Specification.new do |s|
  s.name        = 'basic_api_client'
  s.version     = '2.0.0'
	s.date        = "#{Time.now.strftime("%Y-%m-%d")}"
	s.homepage    = 'https://github.com/jphager2/basic_api_client'
  s.summary     = 'Example of a basic api client that keeps access-token headers'
  s.description = 'Example of a basic api client that keeps access-token headers'
  s.authors     = ['jphager2']
  s.email       = 'jphager2@gmail.com'
  s.files       = files 
  s.license     = 'MIT'

  s.add_runtime_dependency 'curb'
  s.add_runtime_dependency 'json'
end
