
require 'module-cluster'
require 'cascading-configuration'

module ::Persistence
  module Adapter
    module Abstract
      module PrimaryKey
      end
    end
    class Mock
      class Bucket
        class Index
        end
      end
      class Cursor
      end
    end
  end
  module Object
    module Persist
    end
    module Cease
    end
    module Flat
      module File
      end
      module Indexing
      end
    end
    module Complex
      module Array
      end
      module Hash
      end
      module Attributes
      end
      module Persist
      end
      module Cease
      end
      module Indexing
        module Indexes
        end
        module Persist
        end
        module Cease
        end
      end
    end
    module Indexing
      module Indexes
        module Block
        end
        module Explicit
        end
      end
      module Persist
      end
      module Cease
      end
      module Exceptions
      end
    end
  end
  class Port
    class Bucket
      class Index
      end
    end
    module FilePersistence
    end
    module Exceptions
    end
    module Indexing
      module Bucket
        class Index
          module Exceptions
          end
          module ObjectOrientedIndex
          end
          module SortingProcs
          end
        end
      end
    end
  end
  class Cursor
    module Port
    end
    module Indexing
      module Port
      end
    end
  end
end

require_relative './persistence_requires.rb'

class ::Persistence::Cursor
  include ::Persistence::Cursor::Indexing::Port::Bucket  
end

class ::Persistence::Port::Bucket
  include ::Persistence::Port::Indexing::Bucket  
  include ::Persistence::Cursor::Indexing::Port::Bucket  
end

class ::Persistence::Port::Bucket::Index
  include ::Persistence::Cursor::Indexing::Port::Bucket::Index  
end

module ::Persistence
  
  extend ::Persistence::Port::Controller
  
  extend ModuleCluster

  class_or_module_include do |class_or_module|
    
    # two types of objects: complex and flat
    # * complex objects persist ivars
    # * flat objects persist themselves (no ivars)
    
    # if we have a flat object, extend for flat object
    if  class_or_module <= Bignum      or
        class_or_module <= Fixnum      or
        class_or_module <= Complex     or
        class_or_module <= Rational    or
        class_or_module <= TrueClass   or
        class_or_module <= FalseClass  or
        class_or_module <= String      or
        class_or_module <= Symbol      or
        class_or_module <= Regexp      or
        class_or_module <= File        or
        class_or_module <= NilClass
      
      class_or_module.module_eval do
        include ::Persistence::Flat
      end
      
    # otherwise extend as a complex object
    else

      class_or_module.module_eval do
        include ::Persistence::Complex
      end
      
    end
        
    # if you want a different result, use the appropriate module directly
    # * ::Persistence::Complex
    # * ::Persistence::Flat
    
  end
  
  class_or_module_or_instance_extend do
    raise 'Persistence does not expect to be used without class-level support.'
  end
      
end

