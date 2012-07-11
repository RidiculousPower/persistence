
###
# Convenience module for extending flat object types (singletons and instances) with persistence capabilities.
#   Flat object types include: Bignum, Fixnum, Complex, Rational, TrueClass, FalseClass, 
#                              String, Symbol, Regexp, File, NilClass.
#
module ::Persistence::Object::Flat
  
  extend ::Module::Cluster
  
  include ::Persistence::Object::ObjectInstance
  include ::Persistence::Object::Flat::ObjectInstance
  
  cluster( :persistence ).before_include_or_extend.cascade.extend( ::Persistence::Object::ClassInstance,
                                                                   ::Persistence::Object::Flat::ClassInstance )
  
end
