
module ::Persistence::Object::Complex::Indexing::PersistAndCease::ObjectInstance

  ##############
  #  persist!  #
  ##############

  def persist!( *args )

    super

    # index object attributes    
    index_attributes

    return self
  
  end
  
  ######################
  #  index_attributes  #
  ######################
  
  def index_attributes

    attribute_indexes.each do |this_attribute_name, this_attribute_index|
      this_attribute_index.index_object( self )
    end
    
    return self

  end

  #############
  #  persist  #
  #############
  
  def persist( *args )

    index_instance, key, no_key = parse_args_for_index_value_no_value( args )

    unless persistence_id
      if no_key
        raise ::Persistence::Object::Indexing::Exceptions::KeyValueRequired, 
              'Key value required if persistence ID does not already exist for self. : ' + args.to_s
      end
      unless self.persistence_id = index_instance.get_object_id( key )
        # if we got no persistence id, return nil
        return nil
      end
    end
    
    super()
    
    return self

  end
  

end
