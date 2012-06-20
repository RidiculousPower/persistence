
module ::Persistence::Complex
  
  extend ModuleCluster

  include ::Persistence::Port::ObjectInstance
  include_also_extends ::Persistence::Port::ClassInstance

  include ::Persistence::Object::ObjectInstance
  include_also_extends ::Persistence::Object::ClassInstance

  include_also_extends ::Persistence::Cursor::ClassInstance
  
  include ::Persistence::Object::Complex::ObjectInstance
  include_also_extends ::Persistence::Object::Complex::ClassInstance

  include ::Persistence::Object::Indexing::ObjectInstance
  include_also_extends ::Persistence::Object::Indexing::ClassInstance

  include_also_extends ::Persistence::Cursor::Indexing::ClassInstance

  include ::Persistence::Object::Complex::Indexing::ObjectInstance
  include_also_extends ::Persistence::Object::Complex::Indexing::ClassInstance
  
end
