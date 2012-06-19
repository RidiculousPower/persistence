
module ::Persistence::Object::Complex::Attributes::PersistenceHash::ArrayInstance

  ##############################
  #  persistence_hash_to_port  #
  ##############################

  def persistence_hash_to_port

    persistence_hash_instance = ::Persistence::Object::Complex::Attributes::HashToPort.new
    persistence_hash_instance.persistence_object = self

    self.each_with_index do |attribute_value, index|
      persistence_hash_instance[ index ] = attribute_value
    end

    return persistence_hash_instance
    
  end

  ############################
  #  load_persistence_value  #
  ############################
  
  def load_persistence_value( attribute_name, attribute_value )
    push( attribute_value )
  end
  
end
