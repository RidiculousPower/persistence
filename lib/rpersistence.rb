
require 'cascading-configuration'

module Rpersistence

  module Adapter
    class Mock
    end
    module Support
      module Enable
      end
      module Initialize
      end
      module PrimaryKey
        module Simple
        end
        module Compound
        end
      end
    end
  end

  class Cursor
    class Mock
    end
    module ParseInitializationArgs
    end
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
    module Flat
      module Configuration
      end
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
        module FileInstance
        end
      end
    end
    module Status
    end
  end
  
  module ClassInstance
    module Configuration
      module Flat
      end
    end
    module Persistence
      module ArrayClass
      end
      module HashClass
      end
      module Flat
        module ParsePersistenceArgs
        end
        module FileInstance
        end
      end
    end
  end
  
  module Mock
    class Object
    end
  end
  
  module Specs
  end

end

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
