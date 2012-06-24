
module ::Persistence::Object::Complex

  extend ModuleCluster::Define::ClusterCascades
  
  include ::Persistence::Object::ObjectInstance
  include_or_extend_cascades_prepend_extends ::Persistence::Object::ClassInstance
  
  include ::Persistence::Object::Complex::ObjectInstance
  include_or_extend_cascades_prepend_extends ::Persistence::Object::Complex::ClassInstance

end
