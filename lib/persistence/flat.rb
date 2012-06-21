
###
# Convenience module for extending flat object types (singletons and instances) with persistence capabilities.
#   Flat object types include: Bignum, Fixnum, Complex, Rational, TrueClass, FalseClass, 
#                              String, Symbol, Regexp, File, NilClass.
#
module ::Persistence::Flat
  
  extend ModuleCluster

  include ::Persistence::Port::ObjectInstance  
  include_also_extends ::Persistence::Port::ClassInstance

  include ::Persistence::Object::ObjectInstance  
  include_also_extends ::Persistence::Object::ClassInstance
  
  include ::Persistence::Object::Flat::ObjectInstance
  include_also_extends ::Persistence::Object::Flat::ClassInstance

  include ::Persistence::Object::Indexing::ObjectInstance  
  include_also_extends ::Persistence::Object::Indexing::ClassInstance

  include ::Persistence::Object::Flat::Indexing::ObjectInstance  
  include_also_extends ::Persistence::Object::Flat::Indexing::ClassInstance
    
end
