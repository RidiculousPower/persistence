
module ::Persistence::Object::Complex::Port::Bucket

  ##################
  #  get_attribute  #
  ##################

  def get_attribute( object, attribute_name )
    
    attribute_value = super

    if attribute_value.is_a?( ::Persistence::Object::Complex::ComplexObject )
      attribute_value.persistence_port = object.persistence_port
      attribute_value = attribute_value.persist
    end
    
    return attribute_value

  end

end
