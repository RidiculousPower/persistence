
module ::Persistence::Object::Complex::Attributes::PersistenceHash

  include ::Persistence::Object::Complex::Attributes::Persistence

  ##############################
  #  persistence_hash_to_port  #
  ##############################

  # returns persistence hash unique key => storage data
  # unique key is an array
  # adapter responsible for constructing actual storage schema for unique identifier described by key
  def persistence_hash_to_port

    persistence_hash = ::Persistence::Object::Complex::Attributes::HashToPort.new
    persistence_hash.persistence_object = self

    persistent_attribute_writers.each do |this_attribute|
      persistence_hash[ this_attribute ] = __send__( this_attribute )
    end

    return persistence_hash

  end

  ###########################
  #  load_persistence_hash  #
  ###########################

  def load_persistence_hash( port, persistence_ivar_hash )

    self.persistence_port = port

    persistence_ivar_hash.each do |this_attribute_name, this_attribute_value|

      if this_attribute_value.is_a?( ::Persistence::Object::Complex::ComplexObject )
        this_attribute_value = this_attribute_value.persist
      end
      
      load_persistence_value( this_attribute_name, this_attribute_value )
      
    end

    return self

  end
  
  ############################
  #  load_persistence_value  #
  ############################
  
  def load_persistence_value( attribute_name, attribute_value )
    
    __send__( attribute_name.write_accessor_name, attribute_value )
  
  end

end
