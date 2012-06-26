
###
# Interface for index on object attributes, which calls attribute method to retrieve value for persistence, 
#   and which will load value from persistence port back into same attribute through setter method.
#
module ::Persistence::Object::Complex::Index::AttributeIndex::AttributeIndexInterface

  include ::Persistence::Object::Index

  include ::CascadingConfiguration::Setting

  ####################
  #  attribute_name  #
  ####################
  
  ###
  # @method attribute_name
  # 
  #   @return [Symbol,String] Name of attribute index indexes.
  #
  
  # @method attribute_name=( attribute_name )
  #
  #   @param attribute_name Name of attribute to index
  #
  
  attr_setting :attribute_name

  ##################
  #  index_object  #
  ##################

  def index_object( object )

    # get attribute value
    attribute_value = object.__send__( attribute_name )

    # store in super - key/value index
    return super( object, attribute_value )
    
  end
  
end
