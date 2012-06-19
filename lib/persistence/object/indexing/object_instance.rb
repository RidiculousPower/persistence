
module ::Persistence::Object::Indexing::ObjectInstance
  
  include ::Persistence::Object::Indexing::ParsePersistenceArgs
  include ::Persistence::Object::Indexing::Indexes::Explicit::ObjectInstance
  include ::Persistence::Object::Indexing::Indexes::Block::ObjectInstance
  include ::Persistence::Object::Indexing::Indexes
  include ::Persistence::Object::Indexing::Persist::ObjectInstance
  include ::Persistence::Object::Indexing::Cease::ObjectInstance
  
end
