require 'module-cluster'

require 'cascading-configuration'
#require_relative '../../ruby/cascading-configuration/lib/cascading-configuration.rb'
 
basepath = 'persistence'

files = [ ]

# Abstract Adapter
files.concat [
  
  'adapter/abstract',
  'adapter/abstract/enable_disable',
  'adapter/abstract/primary_key/id_property_string',
  'adapter/abstract/primary_key/simple'
  
]

# Mock Adapter
files.concat [
  
  'adapter/mock/bucket/index/index_interface',
  'adapter/mock/bucket/index',
  'adapter/mock/bucket/bucket_interface',
  'adapter/mock/bucket',
  'adapter/mock/cursor/cursor_interface',
  'adapter/mock/cursor',
  'adapter/mock/adapter_interface',
  'adapter/mock'
  
]

# Object
files.concat [

  'object/parse_persistence_args',

  'object/index',
  
  'object/index_hash',

  'object/index/block_index/block_index_interface',
  'object/index/block_index',
  'object/index/explicit_index/explicit_index_interface',
  'object/index/explicit_index',

  'object/flat/file/file_persistence',
  
  'object/flat/file/contents',
  'object/flat/file/path',
  
  'object/flat/file/class_instance',
  'object/flat/file/object_instance',
  
  'object/class_instance',
  'object/object_instance',

  'object/flat/class_instance',
  'object/flat/object_instance',

  'object/complex/attributes/attributes_array',
  'object/complex/attributes/attributes_hash',
  'object/complex/attributes/default_atomic_non_atomic',
  'object/complex/attributes/hash_to_port',
  'object/complex/attributes',

  'object/complex/complex_object',

  'object/complex/class_and_object_instance',
  'object/complex/class_instance',
  'object/complex/object_instance',

  'object/complex/array/class_instance',
  'object/complex/array/object_instance',

  'object/complex/hash/class_instance',
  'object/complex/hash/object_instance',
  
  'object/complex',
  'object/complex/array',
  'object/complex/hash',

  'object/flat',
  'object/flat/file',

  'object/autodetermine',
  'object',

]

# Port
files.concat [

  'port/controller',

  'port/port_interface',

  'port/bucket/bucket_interface',
  'port/bucket',

  'port'

]

# Cursor
files.concat [

  'cursor/cursor_interface',
  'cursor/atomic',

  'cursor'

]

# Complex Index
files.concat [

  'object/complex/index/attribute_index/attribute_index_interface',
  'object/complex/index/attribute_index'

]

# Port Index
files.concat [

  'port/bucket/bucket_index'

]

# Exceptions
files.concat [
  
  'exception/block_required',
  'exception/conflicting_index_already_declared',
  'exception/duplicate_violates_unique_index',
  'exception/indexing_block_failed_to_generate_keys',
  'exception/indexing_object_requires_keys',
  
  'exception/no_port_enabled',
  'exception/explicit_index_required',
  'exception/key_value_required'
  
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end

require_relative( basepath + '.rb' )
