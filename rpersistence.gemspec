require 'date'

Gem::Specification.new do |spec|

  spec.name                      =  'rpersistence'
  spec.rubyforge_project         =  'rpersistence'
  spec.version                   =  '0.0.1'

  spec.summary                   =  "Persistence layer for Ruby."
  spec.description               =  "Implements abstraction layer for persistence, providing for the simple construction of object storage adapters."
  
  spec.authors                   =  [ 'Asher' ]
  spec.email                     =  'asher@ridiculouspower.com'
  spec.homepage                  =  'http://rubygems.org/gems/rpersistence'
  
  spec.date                      =  Date.today.to_s
  
  spec.files                     = Dir[ '{lib,spec}/**/*',
                                        'README*', 
                                        'LICENSE*' ]

end
