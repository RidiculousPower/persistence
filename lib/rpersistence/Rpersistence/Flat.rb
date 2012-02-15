
module Rpersistence::Flat
  
  extend ModuleCluster

  include Rpersistence::Port::ObjectInstance  
  include_also_extends Rpersistence::Port::ClassInstance

  include Rpersistence::Persistence::Object::ObjectInstance  
  include_also_extends Rpersistence::Persistence::Object::ClassInstance
  
  include Rpersistence::Persistence::Flat::ObjectInstance
  include_also_extends Rpersistence::Persistence::Flat::ClassInstance

  include Rpersistence::Persistence::Object::Indexing::ObjectInstance  
  include_also_extends Rpersistence::Persistence::Object::Indexing::ClassInstance

  include Rpersistence::Persistence::Flat::Indexing::ObjectInstance  
  include_also_extends Rpersistence::Persistence::Flat::Indexing::ClassInstance
    
end
