# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'smee'
  s.version     = '0.0.2'
  s.date        = '2020-02-26'
  s.summary     = 'A programmatic client for Smee.'
  s.description =
    'A programmatic client for Smee. Used to listen for events from Smee.io.'
  s.authors     = ['Jason Etcovitch']
  s.email       = 'jasonetco@gmail.com'
  s.files       = ['lib/smee.rb']
  s.homepage    =
    'https://github.com/JasonEtco/smee-client-rb'
  s.license     = 'MIT'

  s.required_ruby_version     = '>= 2.0.0'

  s.add_dependency('ld-eventsource', '~> 1.0')
  s.add_dependency('httparty', '~> 0.18.0')
end
