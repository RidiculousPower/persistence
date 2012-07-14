
###
# Convenience module for extending complex object types (singletons and instances) with persistence capabilities.
#   Complex object types include all objects except: Bignum, Fixnum, Complex, Rational, TrueClass, FalseClass, 
#                                                    String, Symbol, Regexp, File, NilClass, File, Array, Hash.
#
module ::Persistence::Object::Complex

  extend ::Module::Cluster
  
  include ::Persistence::Object::ObjectInstance
  include ::Persistence::Object::Complex::ObjectInstance
  
  cluster( :persistence ).before_include_or_extend.cascade.extend( ::Persistence::Object::ClassInstance,
                                                                   ::Persistence::Object::Complex::ClassInstance )

end
