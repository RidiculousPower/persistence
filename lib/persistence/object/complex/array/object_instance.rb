
###
# Instance methods for array objects enabled with persistence capabilities.
#
module ::Persistence::Object::Complex::Array::ObjectInstance
  
  #############
  #  persist  #
  #############
  
  def persist( *args )
    
    index, key, no_key = parse_object_args_for_index_value_no_value( args, true )
    
    if index
      global_id = index.get_object_id( key )
    else
      global_id = key
    end
    
    persistence_bucket.adapter_bucket.get_object( global_id ).each do |this_index, this_value|
      self[ this_index ] = this_value
    end
    
    return self
    
  end

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
