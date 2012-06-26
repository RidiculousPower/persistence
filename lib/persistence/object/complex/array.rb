
###
# Convenience module for extending array types (singletons and instances) with persistence capabilities.
#
module ::Persistence::Object::Complex::Array

  extend ModuleCluster::Define::ClusterCascades
  
  include ::Persistence::Object::Complex
  
  include ::Persistence::Object::Complex::Array::ObjectInstance
  include_or_extend_cascades_prepend_extends ::Persistence::Object::Complex::Array::ClassInstance

end
