
###
# Interface for Port implementation. Provided separately for easy overriding.
#
module ::Persistence::Port::PortInterface

  include ::Persistence::Object::Flat::File::FilePersistence

  ################
  #  initialize  #
  ################

  ###
  #
  # @param port_name Name to use to identify port instance.
  #
  # @param adapter_instance Adapter instance for which port instance will be operative.
  #
  def initialize( port_name, adapter_instance )

    super() if defined?( super )
    
    @buckets = { }
    
    @instances = ::UniqueArray.new
    
    @name    = port_name
    @adapter = adapter_instance
    
    @enabled = false
    
  end
  
  #############
  #  adapter  #
  #############
  
  ###
  # Retrieve parallel adapter instance.
  #
  # @return [Object] Adapter instance.
  #
  def adapter
    
    unless @adapter
      raise 'Persistence port must be enabled first.'
    end
    
    return @adapter
    
  end

  ##########
  #  name  #
  ##########

  ###
  # @!attribute [reader] Name of bucket
  #
  # @return [Symbol,String] Name.
  #
  attr_reader :name

  ############
  #  enable  #
  ############
  
  ###
  # Enable port.
  #
  # @return self
  #
  def enable
    @enabled = true
    @adapter.enable
    @buckets.each do |this_bucket_name, this_bucket|
      this_bucket.initialize_for_port( self )
    end
    return self
  end

  #############
  #  disable  #
  #############

  ###
  # Disable port.
  #
  # @return self
  #
  def disable

    @enabled = false

    @instances.delete_if do |this_instance|
      this_instance.instance_persistence_port = nil
      true
    end

    @buckets.each do |this_bucket_name, this_bucket|
      this_bucket.disable
    end

    @adapter.disable

    return self

  end

  ##############
  #  enabled?  #
  ##############

  ###
  # Query whether port is enabled.
  #
  # @return [true,false] Whether port is enabled.
  #
  def enabled?
    return @enabled
  end

  ###############
  #  disabled?  #
  ###############

  ###
  # Query whether port is disabled.
  #
  # @return [true,false] Whether port is disabled.
  #
  def disabled?

    return ! @enabled
  end
  
  #############
  #  buckets  #
  #############

  ###
  # @!attribute [reader] Hash of buckets.
  #
  # @return [Hash{Symbol,String=>Persistence::Port::Bucket] Bucket Hash.
  #
  attr_reader :buckets
  
  #######################
  #  register_instance  #
  #######################
  
  ###
  # @private
  #
  # Register an instance as using this port. This is used to disable references to port when port is disabled.
  #
  def register_instance( instance )
    
    @instances.push( instance )
    
    return self
    
  end

  #################################################
  #  initialize_persistence_bucket_from_instance  #
  #################################################

  ###
  # @private
  #
  # Use a bucket instance that has already been created with this port.
  #
  def initialize_persistence_bucket_from_instance( bucket_instance )

    @buckets[ bucket_instance.name.to_sym ] = bucket_instance

    bucket_instance.initialize_for_port( self )
    
    return bucket_instance
    
  end
  
  ########################
  #  persistence_bucket  #
  ########################
  
  ###
  # Get persistence bucket configured for this port.
  #
  # @param bucket_name Name of bucket.
  #
  # @return [Persistence::Port::Bucket] Bucket instance.
  #
  def persistence_bucket( bucket_name )
    
    bucket_instance = nil

    bucket_name = bucket_name.to_sym

    unless bucket_instance = @buckets[ bucket_name ]
      @buckets[ bucket_name ] = bucket_instance = ::Persistence::Port::Bucket.new( self, bucket_name )
    end      
    
    return bucket_instance
    
  end

  ###################################
  #  get_bucket_name_for_object_id  #
  ###################################
  
  ###
  # @private
  #
  # Use Object persistence ID to retrieve the name of the bucket in which object is currently being stored.
  #
  # @param global_id Object persistence ID that owns indexed entries.
  #
  # @return [String] Name of bucket.
  #
  def get_bucket_name_for_object_id( global_id )
    
    return adapter.get_bucket_name_for_object_id( global_id )

  end

  #############################
  #  get_class_for_object_id  #
  #############################
  
  ###
  # @private
  #
  # Use Object persistence ID to retrieve the class of the object.
  #
  # @param global_id Object persistence ID that owns indexed entries.
  #
  # @return [String] Name of bucket.
  #
  def get_class_for_object_id( global_id )

    return adapter.get_class_for_object_id( global_id )

  end

  #################
  #  put_object!  #
  #################

  ###
  # @private
  #
  # Persist object in persistence port. Object configuration will be used to determine where and how.
  #
  # @return [Object] Object persistence ID
  #
  def put_object!( object )    

    return object.persistence_bucket.put_object!( object )

  end

  ####################
  #  delete_object!  #
  ####################

  ###
  # @private
  #
  # Delete object in persistence port.
  #
  # @param global_id Object persistence ID.
  #
  # @return [String] Name of bucket.
  #
  def delete_object!( global_id )
  
    persistence_hash_from_port = nil
    
    bucket = get_bucket_name_for_object_id( global_id )
    
    if bucket
      persistence_hash_from_port = persistence_bucket( bucket ).delete_object!( global_id )
    end
    
    return persistence_hash_from_port
    
  end
  
  ################
  #  get_object  #
  ################

  ###
  # @private
  #
  # Get object from persistence port.
  #
  # @param global_id Object persistence ID.
  #
  # @return [Object] Persisted object instance.
  #
  def get_object( global_id )
        
    object = nil
        
    bucket = get_bucket_name_for_object_id( global_id )
    
    if bucket
      object = persistence_bucket( bucket ).get_object( global_id )
    end

    return object
    
  end

  #####################
  #  get_flat_object  #
  #####################

  ###
  # @private
  #
  # Get flat object from persistence port.
  #
  # @param global_id Object persistence ID to persist from port.
  #
  # @return [Object] Persisted object instance.
  #
  def get_flat_object( global_id )
    
    flat_object = nil
    
    bucket = get_bucket_name_for_object_id( global_id )

    if bucket
      flat_object = persistence_bucket( bucket ).get_flat_object( global_id )
    end
    
    return flat_object
    
  end

  ################################
  #  persists_files_by_content?  #
  ################################

  def persists_files_by_content?
    
    persists_files_by_content = nil
    
    persists_files_by_content = super
    
    if persists_files_by_content.nil?
      persists_files_by_content = ::Persistence.persists_files_by_content?
    end
    
    return persists_files_by_content
    
  end

  #############################
  #  persists_files_by_path?  #
  #############################

  def persists_files_by_path?
    
    persists_files_by_path = nil
    
    persists_files_by_path = super
    
    if persists_files_by_path.nil?
      persists_files_by_path = ::Persistence.persists_files_by_path?
    end
    
    return persists_files_by_path
    
  end

  #####################################
  #  persists_file_paths_as_objects?  #
  #####################################

  def persists_file_paths_as_objects?
    
    persists_file_paths_as_objects = nil
    
    persists_file_paths_as_objects = super
    
    if persists_file_paths_as_objects.nil?
      persists_file_paths_as_objects = ::Persistence.persists_file_paths_as_objects?
    end
    
    return persists_file_paths_as_objects
    
  end

  #####################################
  #  persists_file_paths_as_strings?  #
  #####################################

  def persists_file_paths_as_strings?
    
    persists_file_paths_as_strings = nil
    
    persists_file_paths_as_strings = super
    
    if persists_file_paths_as_strings.nil?
      persists_file_paths_as_strings = ::Persistence.persists_file_paths_as_strings?
    end
    
    return persists_file_paths_as_strings
    
  end

end
