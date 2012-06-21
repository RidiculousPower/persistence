
require 'module-cluster'
require 'cascading-configuration'

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

# post-require setup in Ruby namespace
require_relative './setup.rb'

###
# Primary interface for enabling persistence for a given object type.
#
module ::Persistence
  
  extend ::Persistence::Port::Controller
  
  extend ModuleCluster

  class_or_module_include do |class_or_module|
    
    # two types of objects: complex and flat
    # * complex objects persist ivars
    # * flat objects persist themselves (no ivars)
    
    # if we have a flat object, extend for flat object
    if  class_or_module <= ::Bignum      or
        class_or_module <= ::Fixnum      or
        class_or_module <= ::Complex     or
        class_or_module <= ::Rational    or
        class_or_module <= ::TrueClass   or
        class_or_module <= ::FalseClass  or
        class_or_module <= ::String      or
        class_or_module <= ::Symbol      or
        class_or_module <= ::Regexp      or
        class_or_module <= ::File        or
        class_or_module <= ::NilClass

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

