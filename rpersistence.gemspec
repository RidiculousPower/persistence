require 'date'

Gem::Specification.new do |spec|

  spec.name                      =  'rpersistence'
  spec.rubyforge_project         =  'rpersistence'
  spec.version                   =  '0.0.1'

  spec.summary                   =  "Rpersistence."
  spec.description               =  "Rpersistence."

  spec.authors                   =  [ 'Asher' ]
  spec.email                     =  'asher@ridiculouspower.com'
  spec.homepage                  =  'http://rubygems.org/gems/rpersistence'

  spec.add_dependency            'module-cluster'
  spec.add_dependency            'accessor-utilities'
  spec.add_dependency            'cascading-configuration'

  spec.date                      =  Date.today.to_s
  
  spec.files                     = Dir[ 'lib/**/*',
                                        'spec/**/*',
                                        'README*', 
                                        'LICENSE*' ]

end
