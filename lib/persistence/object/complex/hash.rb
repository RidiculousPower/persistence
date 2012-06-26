
###
# Convenience module for extending hash types (singletons and instances) with persistence capabilities.
#
module ::Persistence::Object::Complex::Hash

  extend ModuleCluster::Define::ClusterCascades
  
  include ::Persistence::Object::Complex
  
  include ::Persistence::Object::Complex::Hash::ObjectInstance
  include_or_extend_cascades_prepend_extends ::Persistence::Object::Complex::Hash::ClassInstance

end
