
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
  
  'adapter/mock/bucket/index/interface',
  'adapter/mock/bucket/index',
  'adapter/mock/bucket/interface',
  'adapter/mock/bucket',
  'adapter/mock/cursor/interface',
  'adapter/mock/cursor',
  'adapter/mock/interface',
  'adapter/mock'
  
]

# Object
files.concat [

  'object/persistence_id',

  'object/persist/class_instance',
  'object/persist/object_instance',

  'object/cease/class_instance',
  'object/cease/object_instance',

  'object/equality',

  'object/suspend',
  
  'object/class_instance',
  'object/object_instance'

]

# Flat Object
files.concat [

  'object/flat/persistence_hash',

  'object/flat/class_instance',
  'object/flat/object_instance',
  
  'object/flat/file/class_instance',
  'object/flat/file/object_instance',
  
  'object/flat/file/contents',
  'object/flat/file/path'

]

# Complex Object
files.concat [

  'object/complex/attributes/attributes_array',
  'object/complex/attributes/attributes_hash',
  'object/complex/attributes/hash_to_port',
  'object/complex/attributes/flat',
  'object/complex/attributes/persistence',
  'object/complex/attributes/persistence_hash',
  'object/complex/attributes/persistence_hash/array_instance',
  'object/complex/attributes/persistence_hash/hash_instance',
  'object/complex/attributes/persistent_attributes',
  'object/complex/attributes',

  'object/complex/equality',

  'object/complex/persist/object_instance',

  'object/complex/cease/cascades',
  'object/complex/cease/class_instance',
  'object/complex/cease/object_instance',
  'object/complex/cease/cascades/class_instance',
  'object/complex/cease/cascades/object_instance',

  'object/complex/complex_object',

  'object/complex/port',
  'object/complex/port/bucket',

  'object/complex/class_instance',
  'object/complex/object_instance',

  'object/complex/array/class_instance',
  'object/complex/array/object_instance',

  'object/complex/hash/class_instance',
  'object/complex/hash/object_instance'

  
]

# Port
files.concat [

  'port/controller',

  'port/interface',
  'port/adapter_interface',

  'port/bucket/interface',
  'port/bucket/adapter_interface',
  'port/bucket/class_instance',
  'port/bucket/object_instance',
  'port/bucket',

  'port/file_persistence/port_instance',
  'port/file_persistence/bucket_instance',
  'port/file_persistence/class_instance',
  'port/file_persistence',

  'port/class_instance',
  'port/object_instance',

  'port/exceptions/no_port_enabled',

  'port'

]

# Cursor
files.concat [

  'cursor/interface',
  'cursor/atomic',

  'cursor/port/bucket',

  'cursor/class_instance',

  'cursor'

]

# Object indexing
files.concat [

  'object/indexing/indexes',
  'object/indexing/indexes/block/class_instance',
  'object/indexing/indexes/block/object_instance',
  'object/indexing/indexes/explicit/class_instance',
  'object/indexing/indexes/explicit/object_instance',
  'object/indexing/indexes/class_instance',

  'object/indexing/persist/class_instance',
  'object/indexing/persist/object_instance',

  'object/indexing/cease/class_instance',
  'object/indexing/cease/object_instance',

  'object/indexing/exceptions/explicit_index_required',
  'object/indexing/exceptions/key_value_required',

  'object/indexing/parse_persistence_args',

  'object/indexing/class_instance',
  'object/indexing/object_instance'

]

# Flat Indexing
files.concat [

  'object/flat/indexing/class_instance',
  'object/flat/indexing/object_instance'

]

# Complex Indexing
files.concat [

  'object/complex/indexing/indexes/attributes',
  'object/complex/indexing/indexes/attributes/class_instance',

  'object/complex/indexing/persist/object_instance',

  'object/complex/indexing/class_instance',
  'object/complex/indexing/object_instance'

]

# Port Indexing
files.concat [

  'port/indexing/bucket/index/adapter_interface',
  'port/indexing/bucket/index/attribute_index',
  'port/indexing/bucket/index/block_index',
  'port/indexing/bucket/index/bucket_index',
  'port/indexing/bucket/index/explicit_index',

  'port/indexing/bucket/index/interface',

  'port/indexing/bucket/index/object_oriented_index',

  'port/indexing/bucket/index/sorting_procs',

  'port/indexing/bucket/index',
  'port/indexing/bucket',

  'port/indexing/bucket/index/exceptions/block_required',
  'port/indexing/bucket/index/exceptions/conflicting_index_already_declared',
  'port/indexing/bucket/index/exceptions/duplicate_violates_unique_index',
  'port/indexing/bucket/index/exceptions/indexing_block_failed_to_generate_keys',
  'port/indexing/bucket/index/exceptions/indexing_object_requires_keys'

]

# Cursor Indexing
files.concat [

  'cursor/indexing/cursor',
  'cursor/indexing/cursor/atomic',

  'cursor/indexing/port/bucket',
  'cursor/indexing/port/bucket/index',

  'cursor/indexing/class_instance'

]

# Public Interface
files.concat [

  'complex',
  'flat'

]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end

require_relative( basepath + '.rb' )
