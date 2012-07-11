
###
# Convenience module for extending hash types (singletons and instances) with persistence capabilities.
#
module ::Persistence::Object::Complex::Hash

  extend ::Module::Cluster
  
  include ::Persistence::Object::Complex
  
  include ::Persistence::Object::Complex::Hash::ObjectInstance
  cluster( :persistence ).before_include_or_extend.cascade.extend( ::Persistence::Object::Complex::Hash::ClassInstance )

end
