
###
# Convenience module for extending flat object types (singletons and instances) with persistence capabilities.
#   Flat object types include: Bignum, Fixnum, Complex, Rational, TrueClass, FalseClass, 
#                              String, Symbol, Regexp, File, NilClass.
#
module ::Persistence::Object::Flat
  
  extend ModuleCluster::Define::ClusterCascades
  
  include ::Persistence::Object::ObjectInstance
  include_or_extend_cascades_prepend_extends ::Persistence::Object::ClassInstance
  
  include ::Persistence::Object::Flat::ObjectInstance
  include_or_extend_cascades_prepend_extends ::Persistence::Object::Flat::ClassInstance

end
