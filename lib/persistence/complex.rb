
###
# Convenience module for extending complex object types (singletons and instances) with persistence capabilities.
#   Complex object types are object types not included in Flat object types.
#   Flat object types include: Bignum, Fixnum, Complex, Rational, TrueClass, FalseClass, 
#                              String, Symbol, Regexp, File, NilClass.
#
module ::Persistence::Complex
  
  extend ModuleCluster

  include ::Persistence::Port::ObjectInstance
  include_also_extends ::Persistence::Port::ClassInstance

  include ::Persistence::Object::ObjectInstance
  include_also_extends ::Persistence::Object::ClassInstance

  include_also_extends ::Persistence::Cursor::ClassInstance
  
  include ::Persistence::Object::Complex::ObjectInstance
  include_also_extends ::Persistence::Object::Complex::ClassInstance

  include ::Persistence::Object::Indexing::ObjectInstance
  include_also_extends ::Persistence::Object::Indexing::ClassInstance

  include_also_extends ::Persistence::Cursor::Indexing::ClassInstance

  include ::Persistence::Object::Complex::Indexing::ObjectInstance
  include_also_extends ::Persistence::Object::Complex::Indexing::ClassInstance
  
end
