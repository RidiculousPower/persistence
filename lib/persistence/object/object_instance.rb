
###
# Instance methods for any objects enabled with persistence capabilities.
#
module ::Persistence::Object::ObjectInstance
  
  include ::Persistence::Object::ParsePersistenceArgs

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Hash
  
  #######################
  #  persistence_port=  #
  #######################

  attr_local_configuration :persistence_port

  ###
  # Assign a persistence port to be used with this object.
  #
  # @overload persistence_port=( port_name )
  #    
  #   @param port_name Name of port to be used. Expects port by name to be available in Persistence controller.
  #
  # @overload persistence_port=( port_instance )
  #
  #   @param port_instance Port instance to use.
  #
  def persistence_port=( persistence_port_class_or_name )

    case persistence_port_class_or_name
      
      when ::Symbol, ::String
      
        super( ::Persistence.port_for_name_or_port( persistence_port_class_or_name, true ) )
      
      else

        if persistence_port_class_or_name.respond_to?( :persistence_port )
          super( persistence_port_class_or_name.persistence_port )
        end
      
    end
      
    
    return self
    
  end

  ######################
  #  persistence_port  #
  ######################
  
  ###
  # Get persistence port that will be used with this object. Will use instance persistence port if no port is assigned,
  #   which will result in using the current port if no instance persistence port is specified.
  #
  # @return [Persistence::Port,nil] Persistence port instance.
  #
  def persistence_port

    # if specified at instance level, use specified value
    # otherwise, use value stored in class  
    return super || self.class.instance_persistence_port

  end
  
  #########################
  #  persistence_bucket=  #
  #########################

  attr_instance_setting :persistence_bucket

  ###
  # Assign a persistence bucket to be used with this object.
  #
  # @overload instance_persistence_bucket=( bucket_name )
  #    
  #   @param port_name [Symbol,String] Name of port to be used. Expects port by name to be available 
  #     in Persistence controller.
  #
  # @overload instance_persistence_bucket=( bucket_instance )
  #
  #   @param port_instance [Persistence::Port::Bucket,nil] Persistence::Port::Bucket instance to use.
  #
  def persistence_bucket=( persistence_bucket_class_or_name )
    
    if persistence_bucket_class_or_name.nil?
      
      super( nil )
      
    elsif persistence_bucket_class_or_name.is_a?( ::Persistence::Port::Bucket )
    
      super( persistence_bucket_class_or_name )
    
    elsif persistence_bucket_class_or_name.respond_to?( :instance_persistence_bucket )

      # if arg responds to :instance_persistence_bucket we use arg's bucket
      super( persistence_bucket_class_or_name.instance_persistence_bucket )

    elsif ! ( persistence_bucket_class_or_name.is_a?( String )  or 
              persistence_bucket_class_or_name.is_a?( Symbol ) )   and 
          persistence_bucket_class_or_name.respond_to?( :persistence_bucket )
      
      # if arg responds to :persistence_bucket we use arg's bucket
      super( persistence_bucket_class_or_name.persistence_bucket )
    
    else
      
      # otherwise we use arg as a symbol
      # this means classnames are ok (which are default)
      self.persistence_bucket = persistence_port.persistence_bucket( persistence_bucket_class_or_name.to_sym )
    
    end
    
    return self
    
  end

  ########################
  #  persistence_bucket  #
  ########################
  
  ###
  # Get persistence bucket that will be used with this object. Will use name of class if bucket
  #   does not already exist.
  #
  # @return [Persistence::Port,nil] Persistence port instance.
  #
  def persistence_bucket

    # if specified at instance level, use specified value
    # otherwise, use value stored in class
    return super || self.class.instance_persistence_bucket

  end

  ####################
  #  persistence_id  #
  ####################
  
  ###
  # Get persistence ID, used to identify unique objects.
  #
  attr_instance_setting :persistence_id

  ##############
  #  persist!  #
  ##############
  
  ###
  # Store object to persistence port. Will cause all non-atomic properties to be updated if object has already
  #   been persisted.
  #
  # @overload persist!
  #
  # @overload persist!( index_name, key )
  # 
  #   @param index_name [Symbol,String] Name of index for explicit key-based indexing.
  #   @param key [Object] Key for explicit indexing.
  #
  # @overload persist!( index_name_key_hash )
  #
  #   @param index_name_key_hash [Hash{Symbol,String=>Object}] Name of index for explicit key-based indexing,
  #     pointing to index value.
  #
  # @overload persist!( index_instance, key )
  #
  #   @param index_instance [Symbol,String] Name of index for explicit key-based indexing.
  #   @param key [Object] Key for explicit indexing.
  #
  # @overload persist!( index_instance_key_hash )
  #
  #   @param index_instance_key_hash [Hash{Persistence::Object::Index=>Object}] Name of index  
  #     for explicit key-based indexing, pointing to index value.
  #
  # @return self
  #
  def persist!( *args )
    
    index_instance, key, no_key = parse_args_for_index_value_no_value( args, false )

    # call super to ensure object is persisted
    unless persistence_port
      raise ::Persistence::Exception::NoPortEnabled, 'No persistence port currently enabled.'
    end

    self.persistence_id = persistence_bucket.put_object!( self )

    if index_instance

      # if we have an index make sure that we have a key
      if no_key
        raise ::Persistence::Exception::KeyValueRequired,
              'Key required when specifying index for :persist!'
      end

      # and make sure we have an index that permits arbitrary keys
      unless self.class.explicit_indexes[ index_instance.name ] == index_instance
        puts 'indexes: ' + self.class.explicit_indexes.to_s
        puts 'instance: ' + index_instance.to_s
        puts 'name: ' + index_instance.name.to_s
        raise ::Persistence::Exception::ExplicitIndexRequired,
              'Index ' + index_instance.name.to_s + ' was not declared as an explicit index '
              'and thus does not permit arbitrary keys.'
      end

      index_instance.index_object( self, key )
      
    end
    
    unless self.class.block_indexes.empty?
      self.class.block_indexes.each do |this_index_name, this_block_index|
        this_block_index.index_object( self )
      end
    end
    
    return self
    
  end
  
  ################
  #  persisted?  #
  ################

  ###
  # Query whether object is persisted in port.
  #
  # @return [true,false] Whether object is persisted.
  #
  def persisted?
    
    bucket_name = persistence_port.get_bucket_name_for_object_id( persistence_id )
    
    return bucket_name ? true : false

  end
  
  ############
  #  cease!  #
  ############

  ###
  # Remove object properties stored for object from persistence bucket and indexes.
  #
  def cease!

    self.class.indexes.each do |this_index_name, this_index|
      this_index.delete_keys_for_object_id!( persistence_id )
    end

    persistence_hash_from_port = persistence_bucket.delete_object!( persistence_id )
    
    self.persistence_id = nil
    
    return persistence_hash_from_port

  end
    
  ######################
  #  explicit_indexes  #
  ######################
  
  ###
  #
  # @method explicit_indexes
  #
  # Hash holding explicit indexes: index_name => index.
  #
  # @return [CompositingHash{Symbol,String=>Persistence::Object::Index::ExplicitIndex}]
  #
  attr_module_hash :explicit_indexes, ::Persistence::Object::IndexHash
  
  ###################
  #  block_indexes  #
  ###################
  
  ###
  #
  # @method block_indexes
  #
  # Hash holding block indexes: index_name => index.
  #
  # @return [CompositingHash{Symbol,String=>Persistence::Object::Index::BlockIndex}]
  #
  attr_module_hash :block_indexes, ::Persistence::Object::IndexHash
  
  #############
  #  indexes  #
  #############

  ###
  #
  # @method indexes
  #
  # Hash holding indexes: index_name => index.
  #
  # @return [CompositingHash{Symbol,String=>Persistence::Object::Index}]
  #
  attr_module_hash :indexes do
    
    #======================#
    #  child_pre_set_hook  #
    #======================#
    
    def child_pre_set_hook( index_name, index_instance )

      child_instance = nil

      case index_instance
        when ::Persistence::Object::Index::ExplicitIndex
          child_instance = configuration_instance.explicit_indexes[ index_name ]
        when ::Persistence::Object::Index::BlockIndex
          child_instance = configuration_instance.block_indexes[ index_name ]                  
        when ::Persistence::Object::Complex::Index::AttributeIndex
          child_instance = configuration_instance.attribute_indexes[ index_name ]
      end

      return child_instance
      
    end
    
  end
  
end