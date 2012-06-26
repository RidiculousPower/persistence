
###
# Module used for common methods for attributes arrays.
#
module ::Persistence::Object::Complex::Attributes::AttributesArray
  
  #####################
  #  has_attributes?  #
  #####################
  
  ###
  # Query whether this array includes attribute(s).
  #
  # @overload has_attributes?( attribute_name, ... )
  #
  #     @param attribute_name [Symbol,String] Attribute to query.
  #
  # @return [true,false] Whether this hash/array includes attribute(s).
  #
  def has_attributes?( *attributes )
    
    has_attributes = false
    
    attributes.each do |this_attribute|
      break unless has_attributes = include?( this_attribute )
    end
  
    return has_attributes
    
  end
  
end
