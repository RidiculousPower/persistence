
module ::Persistence::Object::Complex::Index::AttributeIndex::AttributeIndexInterface

  include ::Persistence::Object::Index

  include ::CascadingConfiguration::Setting

  ####################
  #  attribute_name  #
  ####################

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
