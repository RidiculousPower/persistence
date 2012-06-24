
module ::Persistence::Port::PortInterface

  include ::Persistence::Object::Flat::File::FilePersistence

  ################
  #  initialize  #
  ################

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
  
  def adapter
    
    unless @adapter
      raise 'Persistence port must be enabled first.'
    end
    
    return @adapter
    
  end

  ##########
  #  name  #
  ##########

  attr_reader :name

  ############
  #  enable  #
  ############

  def enable
    @enabled = true
    @adapter.enable
    @buckets.each do |this_bucket_name, this_bucket|
      this_bucket.initialize_for_port( self )
    end
    return self
  end

  ##############
  #  enabled?  #
  ##############

  def enabled?
    return @enabled
  end

  ###############
  #  disabled?  #
  ###############

  def disabled?

    return ! @enabled
  end
  
  #############
  #  disable  #
  #############

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

  #############
  #  buckets  #
  #############

  attr_reader :buckets
  
  #######################
  #  register_instance  #
  #######################
  
  def register_instance( instance )
    
    @instances.push( instance )
    
    return self
    
  end

  #################################################
  #  initialize_persistence_bucket_from_instance  #
  #################################################

  def initialize_persistence_bucket_from_instance( bucket_instance )

    @buckets[ bucket_instance.name.to_sym ] = bucket_instance

    bucket_instance.initialize_for_port( self )
    
    return bucket_instance
    
  end
  
  ########################
  #  persistence_bucket  #
  ########################

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
  
  def get_bucket_name_for_object_id( global_id )
    return adapter.get_bucket_name_for_object_id( global_id )
  end

  #############################
  #  get_class_for_object_id  #
  #############################
  
  def get_class_for_object_id( global_id )
    return adapter.get_class_for_object_id( global_id )
  end

  #################
  #  put_object!  #
  #################

  def put_object!( object )    

    return object.persistence_bucket.put_object!( object )

  end

  ####################
  #  delete_object!  #
  ####################

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
