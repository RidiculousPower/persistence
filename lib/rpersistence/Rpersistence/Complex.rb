
module Rpersistence::Complex
  
  extend ModuleCluster

  include Rpersistence::Port::ObjectInstance
  include_also_extends Rpersistence::Port::ClassInstance

  include Rpersistence::Object::ObjectInstance
  include_also_extends Rpersistence::Object::ClassInstance

  include_also_extends Rpersistence::Cursor::ClassInstance
  
  include Rpersistence::Object::Complex::ObjectInstance
  include_also_extends Rpersistence::Object::Complex::ClassInstance

  include Rpersistence::Object::Indexing::ObjectInstance
  include_also_extends Rpersistence::Object::Indexing::ClassInstance

  include_also_extends Rpersistence::Cursor::Indexing::ClassInstance

  include Rpersistence::Object::Complex::Indexing::ObjectInstance
  include_also_extends Rpersistence::Object::Complex::Indexing::ClassInstance
  
end

class Array
  
  include Rpersistence::Complex
  include Rpersistence::Object::Complex::Attributes::PersistenceHash::ArrayInstance

  include Rpersistence::Object::Complex::Array::ObjectInstance
  extend Rpersistence::Object::Complex::Array::ClassInstance
  
end

class Hash

  include Rpersistence::Complex
  include Rpersistence::Object::Complex::Attributes::PersistenceHash::HashInstance

  include Rpersistence::Object::Complex::Hash::ObjectInstance
  extend Rpersistence::Object::Complex::Hash::ClassInstance
  
end
