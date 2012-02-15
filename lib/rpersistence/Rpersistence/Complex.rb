
module Rpersistence::Complex
  
  extend ModuleCluster

  include Rpersistence::Port::ObjectInstance  
  include_also_extends Rpersistence::Port::ClassInstance

  include Rpersistence::Persistence::Object::ObjectInstance  
  include_also_extends Rpersistence::Persistence::Object::ClassInstance
  
  include Rpersistence::Persistence::Complex::ObjectInstance
  include_also_extends Rpersistence::Persistence::Complex::ClassInstance

  include Rpersistence::Persistence::Object::Indexing::ObjectInstance  
  include_also_extends Rpersistence::Persistence::Object::Indexing::ClassInstance

  include Rpersistence::Persistence::Complex::Indexing::ObjectInstance  
  include_also_extends Rpersistence::Persistence::Complex::Indexing::ClassInstance
  
end
