require 'date'

Gem::Specification.new do |spec|

  spec.name                      =  'persistence'
  spec.rubyforge_project         =  'persistence'
  spec.version                   =  '0.0.1'

  spec.summary                   =  "Persistence."
  spec.description               =  "Persistence."

  spec.authors                   =  [ 'Asher' ]
  spec.email                     =  'asher@ridiculouspower.com'
  spec.homepage                  =  'http://rubygems.org/gems/persistence'

  spec.add_dependency            'module-cluster'
  spec.add_dependency            'accessor-utilities'
  spec.add_dependency            'cascading-configuration'

  spec.date                      =  Date.today.to_s
  
  spec.files                     = Dir[ 'lib/**/*',
                                        'spec/**/*',
                                        'README*', 
                                        'LICENSE*' ]

end
