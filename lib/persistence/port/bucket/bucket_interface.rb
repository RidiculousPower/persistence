
module ::Persistence::Port::Bucket::BucketInterface

  include ::Persistence::Object::Flat::File::FilePersistence

  include ::Enumerable

  ################
  #  initialize  #
  ################

  def initialize( parent_port, bucket_name )

    @name = bucket_name

    @indexes = { }
    @pending_indexes = [ ]

    if parent_port
      initialize_for_port( parent_port )
    end
    
  end

  #########################
  #  initialize_for_port  #
  #########################
  
  def initialize_for_port( port )

    if port = ::Persistence.port_for_name_or_port( port ) and port.enabled?
    
      @parent_port = ::Persistence.port_for_name_or_port( port )
    
      if @parent_port.enabled?
        @adapter_bucket = @parent_port.adapter.persistence_bucket( @name )
      end

      @indexes.each do |this_index_name, this_index_instance|
        this_index_instance.initialize_for_bucket( self )
      end
    
      @pending_indexes.delete_if do |this_pending_index|
        this_pending_index.initialize_for_bucket( self )
        true
      end
    
    else
      
      disable
      
    end
    
  end

  ####################
  #  adapter_bucket  #
  ####################
  
  def adapter_bucket
    
    unless @adapter_bucket
      raise 'Persistence port must be enabled first.'
    end
    
    return @adapter_bucket
    
  end

  ##########
  #  name  #
  ##########
  
  attr_accessor :name
  
  #################
  #  parent_port  #
  #################
  
  attr_accessor :parent_port
  
  #############
  #  disable  #
  #############

  def disable

    @adapter_bucket = nil
    @parent_port = nil
    
    @indexes.each do |this_index_name, this_index|
      this_index.disable
    end
    
  end

  ##################
  #  create_index  #
  ##################
  
  def create_index( index_name, sort_by_proc = nil, & indexing_block )
    
    return create_bucket_index( index_name, false, sort_by_proc, & indexing_block )
    
  end

  ##################################
  #  create_index_with_duplicates  #
  ##################################
  
  def create_index_with_duplicates( index_name, sort_by_proc = nil, sort_duplicates_by_proc = nil, & indexing_block )

    return create_bucket_index( index_name, true, sort_by_proc, sort_duplicates_by_proc, & indexing_block )
    
  end

  ################
  #  pend_index  #
  ################
  
  def pend_index( index_instance )
    
    @pending_indexes.push( index_instance )
    
  end
  
  ###########
  #  index  #
  ###########
  
  def index( index_name, ensure_exists = false )
    
    index_instance = nil
    
    unless index_instance = @indexes[ index_name ]
      if ensure_exists
        raise ::ArgumentError, 'No index found by name ' << index_name.to_s + '.'
      end
    end
    
    return index_instance
    
  end

  ################
  #  has_index?  #
  ################
  
  def has_index?( index_name )
    
    return ( @indexes[ index_name ] ? true : false )
    
  end

  ###########
  #  count  #
  ###########

  def count( *args, & count_block ) 

    return_value = 0
    
    if block_given?
      return_value = super( & count_block )
    elsif args.empty?
      return_value = adapter_bucket.count
    else
      return_value = super( *args )
    end

    return return_value

  end

  #############################
  #  delete_index_for_object  #
  #############################

  def delete_index_for_object( object, index_name )

    return delete_index_for_object_id( object.persistence_id )

  end

  ################################
  #  delete_index_for_object_id  #
  ################################
  
  def delete_index_for_object_id( global_id, index_name )

    return adapter_bucket.delete_index_for_object_id( global_id )

  end

  ###################
  #  get_attribute  #
  ###################

  def get_attribute( object, attribute_name )
    
    primary_key = primary_key_for_attribute_name( object, attribute_name )

    attribute_value = adapter_bucket.get_attribute( object, primary_key )

    if attribute_value.is_a?( ::Persistence::Object::Complex::ComplexObject )
      attribute_value.persistence_port = object.persistence_port
      attribute_value = attribute_value.persist
    end
    
    return attribute_value

  end

  ############
  #  cursor  #
  ############

  ###
  # Create and return cursor instance for this bucket.
  #
  # @return [Persistence::Cursor] New cursor instance.
  #
  def cursor( *args, & block )
    
    cursor_instance = ::Persistence::Cursor.new( self )
    
    if args.count > 0
      cursor_instance.persisted?( *args )
    end
    
    if block_given?
      cursor_instance = cursor_instance.instance_eval( & block )
      cursor_instance.close
    end
    
    return cursor_instance
  
  end

  ###################
  #  atomic_cursor  #
  ###################

  ###
  # Create and return cursor instance for this index enabled to load all object properties as atomic.
  #   See Persistence::Cursor#atomize.
  #
  # @return [Persistence::Cursor] New cursor instance.
  #
  def atomic_cursor( *args )
    
    return cursor( *args ).atomize
  
  end

  ##########
  #  each  #
  ##########

  ###
  # Iterate objects in current bucket.
  #
  # @yield [object] Current object.
  #
  # @yieldparam object Object stored in bucket.
  #
  def each( & block )
    
    return atomic_cursor.each( & block )

  end

  #################
  #  put_object!  #
  #################

  def put_object!( object )    

    return adapter_bucket.put_object!( object )

  end
    
  ################
  #  get_object  #
  ################

  def get_object( global_id )
    
    object = nil
    
    # get the class
    if klass = @parent_port.get_class_for_object_id( global_id )

      object = klass.new
      
      object.persistence_id = global_id

      # if we have non-atomic attributes, load them
      unless klass.non_atomic_attribute_readers.empty?

        if persistence_hash_from_port = get_object_hash( global_id )
          
          object.load_persistence_hash( object.persistence_port, persistence_hash_from_port )

        end

      end

    end
    
    return object

  end
  
  #####################
  #  get_object_hash  #
  #####################

  def get_object_hash( global_id )

    return adapter_bucket.get_object( global_id )

  end

  #####################
  #  get_flat_object  #
  #####################

  def get_flat_object( global_id )

    flat_object = nil

    if persistence_value_hash = adapter_bucket.get_object( global_id )

      if persistence_value_key_data = persistence_value_hash.first
        flat_object = persistence_value_key_data[ 1 ]
        flat_object.persistence_id = global_id
      end
    end

    return flat_object
    
  end

  ####################
  #  delete_object!  #
  ####################

  def delete_object!( global_id )
    
    return adapter_bucket.delete_object!( global_id )
  
  end

  ####################
  #  put_attribute!  #
  ####################
  
  def put_attribute!( object, attribute_name, attribute_value )
    
    primary_key = primary_key_for_attribute_name( object, attribute_name )
    
    return adapter_bucket.put_attribute!( object, primary_key, attribute_value )
    
  end

  #######################
  #  delete_attribute!  #
  #######################

  def delete_attribute!( object, attribute_name )

    primary_key = primary_key_for_attribute_name( object, attribute_name )

    return adapter_bucket.delete_attribute!( object, primary_key )

  end

  ####################################
  #  primary_key_for_attribute_name  #
  ####################################

  def primary_key_for_attribute_name( object, attribute_name )

    return adapter_bucket.primary_key_for_attribute_name( object, attribute_name )

  end

  ################################
  #  persists_files_by_content?  #
  ################################

  def persists_files_by_content?
    
    persists_files_by_content = nil
    
    persists_files_by_content = super
    
    if persists_files_by_content.nil?
      persists_files_by_content = parent_port.persists_files_by_content?
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
      persists_files_by_path = parent_port.persists_files_by_path?
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
      persists_file_paths_as_objects = parent_port.persists_file_paths_as_objects?
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
      persists_file_paths_as_strings = parent_port.persists_file_paths_as_strings?
    end
    
    return persists_file_paths_as_strings
    
  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  #########################
  #  create_bucket_index  #
  #########################
  
  def create_bucket_index( index_name, 
                           permits_duplicates, 
                           sort_by_proc = nil, 
                           sort_duplicates_by_proc = nil, 
                           & indexing_block )
    
    if index_instance = @indexes[ index_name ] and 
       index_instance.permits_duplicates? != permits_duplicates
      
      raise 'Index ' << index_name.to_s + ' has already been declared, ' <<
            'and new duplicates declaration does not match existing declaration.'
    
    end

    index_instance = ::Persistence::Port::Bucket::BucketIndex.new( index_name, 
                                                                          self, 
                                                                          permits_duplicates,
                                                                          sort_by_proc, 
                                                                          sort_duplicates_by_proc,
                                                                          & indexing_block )
    
    @indexes[ index_name ] = index_instance
    
    return index_instance
    
  end

end
