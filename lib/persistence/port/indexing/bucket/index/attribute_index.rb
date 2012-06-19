
module ::Persistence::Port::Indexing::Bucket::Index::AttributeIndex
  
  include ::Persistence::Port::Indexing::Bucket::Index::ObjectOrientedIndex

  attr_accessor :attribute_name

  ##################
  #  index_object  #
  ##################

  def index_object( object )
    
    # get attribute value
    attribute_value = object.__send__( @attribute_name )

    # store in super - key/value index
    return super( object, attribute_value )
    
  end
  
end
