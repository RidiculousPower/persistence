
module ::Persistence::Object::Complex

  extend ModuleCluster
  
  include ::Persistence::Object::ObjectInstance  
  include_also_extends ::Persistence::Object::ClassInstance
  
  include ::Persistence::Object::Complex::ObjectInstance
  include_also_extends ::Persistence::Object::Complex::ClassInstance

end
