
module ::Persistence::Object::Complex::Attributes::AttributesArray
  
  #####################
  #  has_attributes?  #
  #####################
  
  def has_attributes?( *attributes )
    
    has_attributes = false
    
    attributes.each do |this_attribute|
      break unless has_attributes = include?( this_attribute )
    end
  
    return has_attributes
    
  end
  
end
