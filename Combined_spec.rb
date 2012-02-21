$__rpersistence__spec__development = true

specs = [

  [
    'object/spec/',
    'object/flat/spec/',
    'object/complex/spec/',
    'cursor/spec/',
    'port/spec/'
  ],
  
  [
    'object/indexing/spec/',
    'object/flat/indexing/spec/',
    'object/complex/indexing/spec/',
    'cursor/indexing/spec/',
    'port/indexing/spec'
  ],

  [
    'adapters/mock/spec/',
    'adapters/abstract/spec/',
    'adapters/abstract/flat-file/spec/',
    'adapters/marshal/flat-file/spec/',
    'adapters/yaml/flat-file/spec/',
    'adapters/marshal/flat-file/spec/'
  ],
  
  [
    'adapters/kyotocabinet/spec/'
  ],
    
  [ 
    './spec'
  ]
  
]

module Rpersistence
end

specs.each do |this_spec|

  pid = fork do

    describe Rpersistence do

      RSpec::Core::Runner.run( this_spec, $stderr, $stdout )
  
    end
  
  end
  
  Process.wait( pid )
  
end

exec( 'rm -rf /tmp/rpersistence-*' )