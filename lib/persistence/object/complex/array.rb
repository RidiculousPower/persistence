
###
# Convenience module for extending array types (singletons and instances) 
#   with persistence capabilities.
#
module ::Persistence::Object::Complex::Array

  extend ::Module::Cluster
  
  include ::Persistence::Object::Complex
  include ::Persistence::Object::Complex::Array::ObjectInstance

  cascade = cluster( :persistence ).before_include_or_extend.cascade
  cascade.extend( ::Persistence::Object::Complex::Array::ClassInstance )

end
