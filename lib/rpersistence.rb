
require_relative 'namespace_map.rb'

#require_relative 'rpersistence/require_files_for_namespace.rb'
#files = class_hierarchized_files_for_namespace( Rpersistence, true, 'rpersistence' )
#existing_files = Array.new
#files.each do |this_file|
#  if File.exists?( this_file )
#    existing_files.push( this_file )
#  end
#end

require_relative 'rpersistence/Rpersistence.rb'
require_relative 'rpersistence/_private_/Rpersistence.rb'

require_relative 'rpersistence/Rpersistence/Cursor/_private_/ParseInitializationArgs.rb'
require_relative 'rpersistence/Rpersistence/Cursor.rb'
require_relative 'rpersistence/Rpersistence/Cursor/Atomic.rb'
require_relative 'rpersistence/Rpersistence/_private_/Cursor.rb'

require_relative 'rpersistence/Rpersistence/Port.rb'
require_relative 'rpersistence/Rpersistence/_private_/Port.rb'

require_relative 'rpersistence/Rpersistence/ObjectInstance/Accessors.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Attributes.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/_private_/Attributes.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/_private_/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Equality.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Flat/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Inspect.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/_private_/Persistence.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/_private_/ParsePersistenceArgs.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence/ArrayInstance.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence/HashInstance.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence/Flat.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence/Flat/FileInstance.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence/_private_/Flat.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Status.rb'

require_relative 'rpersistence/Rpersistence/ClassInstance/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Flat/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/_private_/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Persistence.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/_private_/Persistence.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Persistence/Flat.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Persistence/Flat/_private_/ParsePersistenceArgs.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Persistence/Flat/FileClassInstance.rb'

require_relative 'rpersistence/String.rb'

require_relative 'rpersistence/Rpersistence/Adapter/Mock.rb'
require_relative 'rpersistence/Rpersistence/Adapter/_private_/Mock.rb'

require_relative 'rpersistence/Rpersistence/Cursor/Mock.rb'
require_relative 'rpersistence/Rpersistence/Cursor/_private_/Mock.rb'

require_relative 'rpersistence/includes_extends_inherits.rb'
