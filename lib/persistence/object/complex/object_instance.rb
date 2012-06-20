
module ::Persistence::Object::Complex::ObjectInstance

  include ::Persistence::Object::Equality

  include ::Persistence::Object::Complex::Attributes
  include ::Persistence::Object::Complex::Attributes::Flat
  include ::Persistence::Object::Complex::Attributes::Persistence
  include ::Persistence::Object::Complex::Attributes::PersistenceHash
  include ::Persistence::Object::Complex::Persist::ObjectInstance
  include ::Persistence::Object::Complex::Cease::ObjectInstance
  include ::Persistence::Object::Complex::Cease::Cascades
  include ::Persistence::Object::Complex::Cease::Cascades::ObjectInstance
  include ::Persistence::Object::Complex::Equality

end
