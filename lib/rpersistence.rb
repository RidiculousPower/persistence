
#---------------------------------------------------------------------------------------------------------#
#-------------------------------------------  Class Map  -------------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

class Rpersistence

  module Adapter
  end

	class Port
	end

	module ObjectInstance
  	module Accessors
  	end
  	module Attributes
  	end
  	module Configuration
  	end
  	module Equality
  	end
  	module Inspect
  	end
  	module ParsePersistenceArgs
  	end
		module Persistence
  		module ArrayInstance
  		end
  		module HashInstance
  		end
  		module Flat
  		end
		end
		module Status
		end
	end
	
	module ClassInstance
		module Persistence
  		module ArrayClass
  		end
  		module HashClass
  		end
  		module Flat
  		end
		end
	end
	
	module Specs
	end

end

#require_relative 'rpersistence/require_files_for_namespace.rb'
#files = class_hierarchized_files_for_namespace( Rpersistence, true, 'rpersistence' )
#existing_files = Array.new
#files.each do |this_file|
#	if File.exists?( this_file )
#		existing_files.push( this_file )
#	end
#end

require_relative 'rpersistence/Rpersistence.rb'
require_relative 'rpersistence/Private/Rpersistence.rb'
require_relative 'rpersistence/Rpersistence/Port.rb'
require_relative 'rpersistence/Rpersistence/Private/Port.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Accessors.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Private/Accessors.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Attributes.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Private/Attributes.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Private/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Equality.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Inspect.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/ParsePersistenceArgs.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Private/Persistence.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence/ArrayInstance.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence/HashInstance.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence/Flat.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Persistence/Private/Flat.rb'
require_relative 'rpersistence/Rpersistence/ObjectInstance/Status.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Configuration.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Persistence.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Private/Persistence.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Persistence/Flat.rb'
require_relative 'rpersistence/Rpersistence/ClassInstance/Persistence/Private/Flat.rb'

require_relative 'rpersistence/String.rb'

require_relative 'rpersistence/includes_extends_inherits.rb'
