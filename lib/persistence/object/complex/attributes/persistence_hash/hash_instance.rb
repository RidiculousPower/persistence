
module ::Persistence::Object::Complex::Attributes::PersistenceHash::HashInstance

  ##############################
  #  persistence_hash_to_port  #
  ##############################

  def persistence_hash_to_port

    hash_to_port = ::Persistence::Object::Complex::Attributes::HashToPort.new
    hash_to_port.persistence_object = self
    
    self.each do |key, data|
      key = persist_as_sub_object_or_attribute_and_return_id_or_value( key )
      hash_to_port[ key ] = data
    end

    return hash_to_port
    
  end

  ############################
  #  load_persistence_value  #
  ############################
  
  def load_persistence_value( attribute_name, attribute_value )
    self[ attribute_name ] = attribute_value
  end
    
end
