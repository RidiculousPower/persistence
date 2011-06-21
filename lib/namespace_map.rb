#---------------------------------------------------------------------------------------------------------#
#-------------------------------------------  Class Map  -------------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

module Rpersistence

  class Adapter
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

# used as a type of flat file for persisting files stored as contents
class File::Contents < String
end
class File::Path < String
end
class Class::Name < String
end
