
###
# Interface implementation for Bucket class instances.
#
module ::Persistence::Adapter::Mock::Bucket::BucketInterface

  include ::Persistence::Adapter::Abstract::PrimaryKey::Simple

  attr_accessor :parent_adapter, :name
  
  ################
  #  initialize  #
  ################
  
  ###
  #
  # @param name Name of bucket.
  #
  def initialize( name )

    super() if defined?( super )

    @name = name

    @objects = { }
    @indexes = { }

  end

  ###########
  #  count  #
  ###########
  
  ###
  # Get the number of objects in this bucket.
  #
  # @return [Integer] Number of objects in this bucket.
  #
  def count
    
    return @objects.count
    
  end

  #################
  #  put_object!  #
  #################

  ###
  # Store object properties in this bucket.
  #
  # @param object Object whose properties are being stored.
  #
  # @return [Integer] Object persistence ID.
  #
  def put_object!( object )

    parent_adapter.ensure_object_has_globally_unique_id( object )
    object_persistence_hash = object.persistence_hash_to_port
    @objects[ object.persistence_id ] = object_persistence_hash

    return object.persistence_id

  end

  ################
  #  get_object  #
  ################

  ###
  # Retrieve object properties from this bucket.
  #
  # @param global_id Object persistence ID to retrieve object properties.
  #
  # @return [Integer] Object persistence ID.
  #
  def get_object( global_id )

    return @objects[ global_id ]

  end
  
  ####################
  #  delete_object!  #
  ####################

  ###
  # Delete object properties from this bucket.
  #
  # @param global_id Object persistence ID to delete object properties.
  #
  # @return [Hash{Symbol,String=>Object}] Hash of property data deleted from port.
  #
  def delete_object!( global_id )

    persistence_hash_in_port = @objects[ global_id ]

    # and now delete the object's ID reference
    @objects.delete( global_id )
    parent_adapter.delete_bucket_for_object_id( global_id )
    parent_adapter.delete_class_for_object_id( global_id )

    return persistence_hash_in_port

  end

  ####################
  #  put_attribute!  #
  ####################

  ###
  # Store object property in this bucket.
  #
  # @param object Object whose properties are being stored.
  # @param attribute_name Name of property being stored.
  # @param attribute_value Value of property to store.
  #
  # @return self
  #
  def put_attribute!( object, attribute_name, attribute_value )

    @objects[ object.persistence_id ] ||= { }
    @objects[ object.persistence_id ][ attribute_name ] = ( attribute_name.is_a?( Symbol ) ? attribute_value : attribute_value.dup )

    return self

  end

  ###################
  #  get_attribute  #
  ###################

  ###
  # Get object property stored in this bucket.
  #
  # @param object Object whose properties are being stored.
  # @param attribute_name Name of property being stored.
  #
  # @return Value of property stored in this bucket for object.
  #
  def get_attribute( object, attribute_name )

    @objects[ object.persistence_id ] ||= { }

    return @objects[ object.persistence_id ][ attribute_name ]

  end

  #######################
  #  delete_attribute!  #
  #######################

  ###
  # Delete object property stored in this bucket.
  #
  # @param object Object whose properties are being stored.
  # @param attribute_name Name of property being stored.
  #
  # @return Value of property deleted from this bucket for object.
  #
  def delete_attribute!( object, attribute_name )
    
    deleted_value = nil
    
    if @objects[ object.persistence_id ]
      deleted_value = @objects[ object.persistence_id ].delete( attribute_name )
    end
    
    return deleted_value

  end

  ############
  #  cursor  #
  ############

  ###
  # Create and return cursor instance for this bucket.
  #
  # @return [Persistence::Adapter::Mock::Cursor] New cursor instance.
  #
  def cursor

    return ::Persistence::Adapter::Mock::Cursor.new( self, nil )

  end

  ##################
  #  create_index  #
  ##################

  ###
  # Create and return index for this bucket.
  #
  # @param index_name Name to be used for index.
  # @param permits_duplicates Whether index permits duplicate entries for the same key.
  #
  # @return [Persistence::Adapter::Mock::Bucket::Index] New index instance.
  #
  def create_index( index_name, permits_duplicates )

    index_instance = ::Persistence::Adapter::Mock::Bucket::Index.new( index_name, self, permits_duplicates )
    @indexes[ index_name ] = index_instance
    
    return index_instance
    
  end

  ###########
  #  index  #
  ###########
  
  ###
  # Get index for this bucket.
  #
  # @param index_name Name of desired index.
  #
  # @return [Persistence::Adapter::Mock::Bucket::Index] Index instance for name.
  #
  def index( index_name )
    
    return @indexes[ index_name ]
    
  end
  
  ##################
  #  delete_index  #
  ##################

  ###
  # Delete index for this bucket.
  #
  # @param index_name Index name to be deleted.
  #
  # @return [Persistence::Adapter::Mock::Bucket::Index] Deleted index instance.
  #
  def delete_index( index_name )

    return @indexes.delete( index_name )

  end
    
  ################
  #  has_index?  #
  ################
  
  ###
  # Reports whether bucket has index by name.
  #
  # @param index_name Index name being queried.
  #
  # @return [true,false] Whether bucket has index by name.
  #  
  def has_index?( index_name )

    return @indexes.has_key?( index_name )

  end

end
