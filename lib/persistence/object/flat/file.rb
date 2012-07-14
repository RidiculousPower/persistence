
###
# Convenience module for extending File with persistence capabilities.
#
module ::Persistence::Object::Flat::File

  extend ::Module::Cluster
  
  include ::Persistence::Object::Flat
  include ::Persistence::Object::Flat::File::ObjectInstance
  
  cascade = cluster( :persistence ).before_include_or_extend.cascade
  cascade.extend( ::Persistence::Object::Flat::File::ClassInstance )
    
end
