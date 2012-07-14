
###
# Interface for Bucket implementation. Provided separately for easy overriding.
#
module ::Persistence::Port::Bucket::BucketInterface

  include ::Persistence::Object::Flat::File::FilePersistence

  include ::Enumerable

  ################
  #  initialize  #
  ################

  ###
  #
  # @param parent_port Port where this bucket is active. Can be nil if no port is yet enabled.
  #
  # @param bucket_name Name of the bucket to open in port.
  #
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
  
  ###
  # Initialize bucket for a port that has been enabled.
  #
  # @param port Parent port in which to initialize bucket.
  #
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
  
  ###
  # Retrieve parallel adapter bucket instance.
  #
  # @return [Object] Adapter bucket instance.
  #
  def adapter_bucket
    
    unless @adapter_bucket
      raise 'Persistence port must be enabled first.'
    end
    
    return @adapter_bucket
    
  end

  ##########
  #  name  #
  ##########
  
  ###
  # @!attribute [accessor] Name of bucket
  #
  # @return [Symbol,String] Name.
  #
  attr_accessor :name
  
  #################
  #  parent_port  #
  #################
  
  attr_accessor :parent_port
  
  #############
  #  disable  #
  #############

  ###
  # @private
  #
  # Disable bucket when port disables. Internal helper method necessary to ensure 
  # that old references don't stick around.
  #
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
  
  ###
  # Create a bucket index, which is a block index that runs on each inserted object, regardless of type.
  #
  def create_index( index_name, sort_by_proc = nil, & indexing_block )
    
    return create_bucket_index( index_name, false, sort_by_proc, & indexing_block )
    
  end

  ##################################
  #  create_index_with_duplicates  #
  ##################################
  
  ###
  # Create a bucket index that permits duplicates.
  #
  def create_index_with_duplicates( index_name, sort_by_proc = nil, sort_duplicates_by_proc = nil, & indexing_block )

    return create_bucket_index( index_name, true, sort_by_proc, sort_duplicates_by_proc, & indexing_block )
    
  end

  ################
  #  pend_index  #
  ################
  
  ###
  # @private
  #
  # Pend index instance for port to be enabled.
  #
  # @param index_instance Instance of index that is waiting for port to be enabled.
  #
  def pend_index( index_instance )
    
    @pending_indexes.push( index_instance )
    
  end
  
  ###########
  #  index  #
  ###########
  
  ###
  # Retrieve index.
  #
  # @param index_name [Symbol,String] Name of index
  # 
  # @param ensure_exists [true,false] Whether exception should be thrown if index does not exist.
  #
  # @return [Persistence::Object::Index] Index instance
  #
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
  
  ###
  # Query whether attribute index(es) exist for object.
  #
  # @overload has_attribute_index?( index_name, ... )
  #
  #   @param index_name Name of requested index.
  #
  # @return [true,false] Whether index(es) exist.
  #
  def has_index?( *indexes )
    
    has_index = false
    
    indexes.each do |this_index|
      break unless has_index = @indexes.has_key?( index_name )
    end
    
    return has_index
    
  end

  ###########
  #  count  #
  ###########

  ###
  # Get the number of objects in index. See {::Enumerable}.
  #
  # @return [Integer] Number of objects in bucket.
  #
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

  ###
  # @private
  #
  # Delete indexed entries for object.
  #
  # @param object Object that owns indexed entries.
  #
  # @param index_name Name of index.
  #
  def delete_index_for_object( object, index_name )

    return delete_index_for_object_id( object.persistence_id )

  end

  ################################
  #  delete_index_for_object_id  #
  ################################
  
  ###
  # @private
  #
  # Delete indexed entries for object.
  #
  # @param global_id Object persistence ID that owns indexed entries.
  #
  # @param index_name Name of index.
  #
  def delete_index_for_object_id( global_id, index_name )

    return adapter_bucket.delete_index_for_object_id( global_id )

  end

  ###################
  #  get_attribute  #
  ###################
  
  ###
  # @private
  #
  # Get attribute for object from port. 
  #
  # @param object Object that owns indexed entries.
  #
  # @param attribute_name Name of attribute.
  #
  def get_attribute( object, attribute_name )
    
    primary_key = primary_key_for_attribute_name( object, attribute_name )

    attribute_value = adapter_bucket.get_attribute( object, primary_key )

    if attribute_value.is_a?( ::Persistence::Object::Complex::ComplexObject )
      attribute_value.persistence_port = object.persistence_port
      attribute_value = attribute_value.persist
    end
    
    return attribute_value

  end

  ####################
  #  put_attribute!  #
  ####################
  
  ###
  # @private
  #
  # Put attribute for object to port. 
  #
  # @param object Object that owns indexed entries.
  #
  # @param attribute_name Name of attribute.
  #
  # @param attribute_value Value to put.
  #
  def put_attribute!( object, attribute_name, attribute_value )
    
    primary_key = primary_key_for_attribute_name( object, attribute_name )
    
    return adapter_bucket.put_attribute!( object, primary_key, attribute_value )
    
  end

  #################
  #  put_object!  #
  #################
  
  ###
  # @private
  #
  # Put object properties to persistence port.
  #
  # @param object Object to persist to port.
  #
  def put_object!( object )    

    return adapter_bucket.put_object!( object )

  end
    
  ################
  #  get_object  #
  ################

  ###
  # @private
  #
  # Get object from persistence port.
  #
  # @param global_id Object persistence ID to persist from port.
  #
  # @return [Object] Persisted object instance.
  #
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

  ###
  # @private
  #
  # Get object properties from persistence port.
  #
  # @param global_id Object persistence ID to persist from port.
  #
  # @return [Hash] Persistence hash from port.
  #
  def get_object_hash( global_id )

    return adapter_bucket.get_object( global_id )

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

  ###
  # @private
  #
  # Delete object from persistence port.
  #
  # @param global_id Object persistence ID to delete from port.
  #
  # @return [Hash] Persistence hash from port.
  #
  def delete_object!( global_id )
    
    return adapter_bucket.delete_object!( global_id )
  
  end

  #######################
  #  delete_attribute!  #
  #######################

  ###
  # @private
  #
  # Delete attribute for object from port. 
  #
  # @param object Object that owns indexed entries.
  #
  # @param attribute_name Name of attribute.
  #
  def delete_attribute!( object, attribute_name )

    primary_key = primary_key_for_attribute_name( object, attribute_name )

    return adapter_bucket.delete_attribute!( object, primary_key )

  end

  ####################################
  #  primary_key_for_attribute_name  #
  ####################################

  ###
  # @private
  #
  # Generate primary key for storage for attribute name on object.
  #
  # @param object Object for which attribute is being stored.
  #
  # @param attribute_name Name of attribute.
  #
  # @return [String] Primary key.
  #
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

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  #########################
  #  create_bucket_index  #
  #########################
  
  ###
  # Internal helper method for common code to create bucket indexs.
  #
  # @param index_name Name of index to create.
  # 
  # @param permits_duplicates Whether index should permit duplicates.
  # 
  # @param sort_by_proc [Proc] Proc to use for sorting objects.
  #
  # @param sort_duplicates_by_proc [Proc] Proc to use for sorting duplicate objects.
  #
  # @yield [object] Block to create index keys on object.
  # @yieldparam object [Object] Object to index.
  #
  # @return [Persistence::Port::Bucket::BucketIndex]
  #
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
