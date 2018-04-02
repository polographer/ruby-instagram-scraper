#!/usr/bin/env ruby
# encoding: utf-8
Gem::Specification.new do |s|
  s.name        = 'ruby-instagram-scraper-ng'
  s.version     = '0.1.8'
  s.date        = '2018-03-28'
  s.summary     = "A simple module for requests to Instagram"
  s.description = "A simple module for requests to Instagram reaching unnoficial api endpoints."
  s.authors     = [ "Sergey Borodanov <s.borodanov@gmail.com>", "Polo Ornelas" ]
  s.email       = "me@poloornelas.mx"
  s.files       = [ "lib/ruby-instagram-scraper.rb", "lib/ruby-instagram-response.rb" ]
  s.test_files  = [ "test/ruby_instagram_scraper_test.rb" ]
  s.homepage    = 'https://github.com/polographer/ruby-instagram-scraper'
  s.license     = 'MIT'
  s.add_development_dependency "bundler", "~> 1.16"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "minitest", "~> 5.0"
end
