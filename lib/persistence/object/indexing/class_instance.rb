
module ::Persistence::Object::Indexing::ClassInstance

  include ::Persistence::Object::Indexing::ParsePersistenceArgs
  include ::Persistence::Object::Indexing::Indexes
  include ::Persistence::Object::Indexing::Indexes::ClassInstance
  include ::Persistence::Object::Indexing::Indexes::Explicit::ClassInstance
  include ::Persistence::Object::Indexing::Indexes::Block::ClassInstance
  include ::Persistence::Object::Indexing::Cease::ClassInstance
  include ::Persistence::Object::Indexing::Persist::ClassInstance
  
end
