require 'date'

Gem::Specification.new do |spec|

  spec.name                      =  'persistence'
  spec.rubyforge_project         =  'persistence'
  spec.version                   =  '0.0.2'

  spec.summary                   =  "Persistence layer designed to take advantage of Ruby's object model. The back-end is abstracted so that many different adapters can be created."
  spec.description               =  "Store and retrieve Ruby objects without thinking twice about how they are stored. Designed for maximum in flexibility and intuitive interface."

  spec.authors                   =  [ 'Asher' ]
  spec.email                     =  'asher@ridiculouspower.com'
  spec.homepage                  =  'http://rubygems.org/gems/persistence'

  spec.add_dependency            'module-cluster'
  spec.add_dependency            'cascading_configuration'

  spec.date                      = Date.today.to_s

  spec.files                     = Dir[ '{lib,spec}/**/*',
                                        'README*', 
                                        'LICENSE*',
                                        'CHANGELOG*' ]

end
