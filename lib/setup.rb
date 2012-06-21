
class ::Array
  
  include ::Persistence::Complex
  include ::Persistence::Object::Complex::Attributes::PersistenceHash::ArrayInstance

  include ::Persistence::Object::Complex::Array::ObjectInstance
  extend ::Persistence::Object::Complex::Array::ClassInstance
  
end

class ::Hash

  include ::Persistence::Complex
  include ::Persistence::Object::Complex::Attributes::PersistenceHash::HashInstance

  include ::Persistence::Object::Complex::Hash::ObjectInstance
  extend ::Persistence::Object::Complex::Hash::ClassInstance
  
end

class ::Persistence::Cursor
  include ::Persistence::Cursor::Indexing::Port::Bucket  
end

class ::Persistence::Port::Bucket
  include ::Persistence::Port::Indexing::Bucket  
  include ::Persistence::Cursor::Indexing::Port::Bucket  
end

class ::Persistence::Port::Bucket::Index
  include ::Persistence::Cursor::Indexing::Port::Bucket::Index  
end
