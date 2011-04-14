#---------------------------------------------------------------------------------------------------------#
#-------------------------------------------  Class Map  -------------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

class Rpersistence

  class Adapter
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

# used as a type of flat file for persisting files stored as contents
class File::Contents < String
end
