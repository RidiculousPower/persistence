
###
# Convenience module for extending complex object types (singletons and instances) with persistence capabilities.
#   Complex object types include all objects except: Bignum, Fixnum, Complex, Rational, TrueClass, FalseClass, 
#                                                    String, Symbol, Regexp, File, NilClass, File, Array, Hash.
#
module ::Persistence::Object::Complex

  extend ModuleCluster::Define::ClusterCascades
  
  include ::Persistence::Object::ObjectInstance
  include_or_extend_cascades_prepend_extends ::Persistence::Object::ClassInstance
  
  include ::Persistence::Object::Complex::ObjectInstance
  include_or_extend_cascades_prepend_extends ::Persistence::Object::Complex::ClassInstance

end
