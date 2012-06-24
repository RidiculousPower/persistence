
###
# Convenience module for extending File with persistence capabilities.
#
module ::Persistence::Object::Flat::File

  extend ModuleCluster::Define::ClusterCascades
  
  include ::Persistence::Object::Flat
  
  include ::Persistence::Object::Flat::File::ObjectInstance
  include_or_extend_cascades_prepend_extends ::Persistence::Object::Flat::File::ClassInstance
    
end
