
module Rpersistence::Complex
  
  extend ModuleCluster

  include Rpersistence::Port::ObjectInstance  
  include_also_extends Rpersistence::Port::ClassInstance

  include Rpersistence::Object::ObjectInstance  
  include_also_extends Rpersistence::Object::ClassInstance
  
  include Rpersistence::Object::Complex::ObjectInstance
  include_also_extends Rpersistence::Object::Complex::ClassInstance

  include Rpersistence::Object::Indexing::ObjectInstance  
  include_also_extends Rpersistence::Object::Indexing::ClassInstance

  include Rpersistence::Object::Complex::Indexing::ObjectInstance  
  include_also_extends Rpersistence::Object::Complex::Indexing::ClassInstance
  
end
