
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
require_relative 'rpersistence/Private/Rpersistence.rb'

require_relative 'rpersistence/Rpersistence/Port.rb'
require_relative 'rpersistence/Rpersistence/Private/Port.rb'

require_relative 'rpersistence/Rpersistence/ObjectInstance/Accessors.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Attributes.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Private/Attributes.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Private/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Equality.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Flat/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Inspect.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Private/Persistence.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Private/ParsePersistenceArgs.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence/ArrayInstance.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence/HashInstance.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence/Flat.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence/Flat/FileInstance.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence/Private/Flat.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Status.rb'

require_relative 'rpersistence/Rpersistence/ClassInstance/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Flat/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Private/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Persistence.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Private/Persistence.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Persistence/Flat.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Persistence/Flat/FileClassInstance.rb'

require_relative 'rpersistence/Rpersistence/Adapter.rb'
require_relative 'rpersistence/Rpersistence/Adapter/Mock.rb'
require_relative 'rpersistence/Rpersistence/Adapter/Private/Mock.rb'

require_relative 'rpersistence/Rpersistence/Adapter/Support/Enable.rb'
require_relative 'rpersistence/Rpersistence/Adapter/Support/Initialize.rb'
require_relative 'rpersistence/Rpersistence/Adapter/Support/PrimaryKey/Simple.rb'
require_relative 'rpersistence/Rpersistence/Adapter/Support/PrimaryKey/Compound.rb'

require_relative 'rpersistence/String.rb'

require_relative 'rpersistence/includes_extends_inherits.rb'
