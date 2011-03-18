
class Rpersistence

  module Define
  end

  module Mock
  end
  
	class Port
	end

	module Klass
	end

	module KlassAndInstance
		module Object
		end
		module ParsePersistenceArguments
		end
	end
	
	module Instance
		module Flat
		end
		module Object
		end
	end

end

require_relative 'rpersistence/Rpersistence.rb'
require_relative 'rpersistence/Rpersistence/Port.rb'

require_relative 'rpersistence/Rpersistence/Klass/Object.rb'
require_relative 'rpersistence/Rpersistence/Klass/Flat.rb'

require_relative 'rpersistence/Rpersistence/KlassAndInstance/Object.rb'
require_relative 'rpersistence/Rpersistence/KlassAndInstance/ParsePersistenceArguments.rb'

require_relative 'rpersistence/Rpersistence/Instance/Array.rb'
require_relative 'rpersistence/Rpersistence/Instance/Flat.rb'
require_relative 'rpersistence/Rpersistence/Instance/Hash.rb'
require_relative 'rpersistence/Rpersistence/Instance/Object.rb'
