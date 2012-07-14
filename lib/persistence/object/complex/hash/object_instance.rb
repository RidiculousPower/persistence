
###
# Instance methods for hash objects enabled with persistence capabilities.
#
module ::Persistence::Object::Complex::Hash::ObjectInstance
    
  #############
  #  persist  #
  #############
  
  def persist( *args )
    
    index, key, no_key = parse_object_args_for_index_value_no_value( args, true )
    
    if index
      global_id = index.get_object_id( key )
    elsif key
      global_id = key
    else
      global_id = persistence_id
    end
    
    port_hash = persistence_bucket.adapter_bucket.get_object( global_id )

    port_hash.each do |this_key, this_value|
      if this_value.is_a?( ::Persistence::Object::Complex::ComplexObject )
        self[ this_key ] = this_value.persist
      else
        self[ this_key ] = this_value
      end
    end
    
    return self
    
  end

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
