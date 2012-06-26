
###
# Index on object attributes, which calls attribute method to retrieve value for persistence, and which
#   will load value from persistence port back into same attribute through setter method.
#
class ::Persistence::Object::Complex::Index::AttributeIndex
  
  include ::Persistence::Object::Complex::Index::AttributeIndex::AttributeIndexInterface
  
end
