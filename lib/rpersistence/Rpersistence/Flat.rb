
module ::Rpersistence::Flat
  
  extend ModuleCluster

  include ::Rpersistence::Port::ObjectInstance  
  include_also_extends ::Rpersistence::Port::ClassInstance

  include ::Rpersistence::Object::ObjectInstance  
  include_also_extends ::Rpersistence::Object::ClassInstance
  
  include ::Rpersistence::Object::Flat::ObjectInstance
  include_also_extends ::Rpersistence::Object::Flat::ClassInstance

  include ::Rpersistence::Object::Indexing::ObjectInstance  
  include_also_extends ::Rpersistence::Object::Indexing::ClassInstance

  include ::Rpersistence::Object::Flat::Indexing::ObjectInstance  
  include_also_extends ::Rpersistence::Object::Flat::Indexing::ClassInstance
    
end
