require 'rubygems'

spec = Gem::Specification.new do |s|
  s.name = 'bing-location'
  s.version = '0.0.2b'
  s.summary = 'Access the Bing Maps API by creating location objects with string based queries or geolocation data'
  s.description = 'Access the Bing Maps API by creating location objects with string based queries or geolocation data'
  s.homepage = 'http://www.dashdingo.org'
  s.files = Dir.glob("**/**/**")
  s.test_files = Dir.glob("test/*")
  s.author = "Justin Reese"
  s.email = "justin.x.reese@gmail.com"
  s.has_rdoc = false
end
