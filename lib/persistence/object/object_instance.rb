
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

  # declare name of persistence port where object will be stored
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
  
  def persistence_port

    # if specified at instance level, use specified value
    # otherwise, use value stored in class  
    return super || self.class.instance_persistence_port

  end
  
  #########################
  #  persistence_bucket=  #
  #########################

  attr_instance_setting :persistence_bucket

  # declare name of persistence bucket where object will be stored
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
  
  def persistence_bucket

    # if specified at instance level, use specified value
    # otherwise, use value stored in class
    return super || self.class.instance_persistence_bucket

  end

  ####################
  #  persistence_id  #
  ####################

  attr_instance_setting :persistence_id

  ##############
  #  persist!  #
  ##############
  
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
      unless explicit_indexes[ index_instance.name ] == index_instance
        raise ::Persistence::Exception::ExplicitIndexRequired,
              'Index ' + index_instance.name.to_s + ' was not declared as an explicit index '
              'and thus does not permit arbitrary keys.'
      end

      index_instance.index_object( self, key )
      
    end
    
    unless block_indexes.empty?
      block_indexes.each do |this_index_name, this_block_index|
        this_block_index.index_object( self )
      end
    end
    
    return self
    
  end
  
  ################
  #  persisted?  #
  ################

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

    indexes.each do |this_index_name, this_index|
      this_index.delete_keys_for_object_id!( persistence_id )
    end

    persistence_hash_from_port = persistence_bucket.delete_object!( persistence_id )
    
    self.persistence_id = nil
    
    return persistence_hash_from_port

  end
    
  ######################
  #  explicit_indexes  #
  ######################
  
  attr_hash :explicit_indexes, ::Persistence::Object::IndexHash
  
  ###################
  #  block_indexes  #
  ###################
  
  attr_hash :block_indexes, ::Persistence::Object::IndexHash
  
  #######################
  #  attribute_indexes  #
  #######################
  
  attr_hash :attribute_indexes, ::Persistence::Object::IndexHash
      
  #############
  #  indexes  #
  #############

  attr_hash :indexes do
    
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
  
  ###########
  #  stop!  #
  ###########

  attr_setting :suspended, :stopped
  
  # suspend atomic writes and quietly suppress explicit calls to persist!
  def stop!

    self.stopped = true

    # if we have a block we stop until the end
    if block_given?
      yield
      resume!
    end

  end

  ##############
  #  suspend!  #
  ##############
  
  # suspend atomic writes and fail explicit calls to persist!
  def suspend!

    self.suspended = true

    # if we have a block we suspend until the end
    if block_given?
      yield
      resume!
    end

  end

  #############
  #  resume!  #
  #############
  
  # resume atomic writes and no longer suppress explicit calls to persist!
  def resume!

    self.suspended = false
    self.stopped = false

  end

end