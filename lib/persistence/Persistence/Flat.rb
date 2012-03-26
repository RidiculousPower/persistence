
module ::Persistence::Flat
  
  extend ModuleCluster

  include ::Persistence::Port::ObjectInstance  
  include_also_extends ::Persistence::Port::ClassInstance

  include ::Persistence::Object::ObjectInstance  
  include_also_extends ::Persistence::Object::ClassInstance
  
  include ::Persistence::Object::Flat::ObjectInstance
  include_also_extends ::Persistence::Object::Flat::ClassInstance

  include ::Persistence::Object::Indexing::ObjectInstance  
  include_also_extends ::Persistence::Object::Indexing::ClassInstance

  include ::Persistence::Object::Flat::Indexing::ObjectInstance  
  include_also_extends ::Persistence::Object::Flat::Indexing::ClassInstance
    
end
