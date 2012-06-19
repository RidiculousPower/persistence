
module ::Persistence::Adapter::Mock::Bucket::Interface

  include ::Persistence::Adapter::Abstract::PrimaryKey::Simple

  attr_accessor :parent_adapter, :name
  
  ################
  #  initialize  #
  ################

  def initialize( name )

    super() if defined?( super )

    @name = name

    @objects = { }
    @indexes = { }

  end

  ###########
  #  count  #
  ###########
  
  def count
    
    return @objects.count
    
  end

  #################
  #  put_object!  #
  #################

  # must be recoverable by information in the object
  # we currently use class and persistence key
  def put_object!( object )

    parent_adapter.ensure_object_has_globally_unique_id( object )
    object_persistence_hash = object.persistence_hash_to_port
    @objects[ object.persistence_id ] = object_persistence_hash

    return object.persistence_id

  end

  ################
  #  get_object  #
  ################

  def get_object( global_id )

    return @objects[ global_id ]

  end
  
  ####################
  #  delete_object!  #
  ####################

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

  def put_attribute!( object, attribute_name, attribute_value )

    @objects[ object.persistence_id ] ||= { }
    @objects[ object.persistence_id ][ attribute_name ] = ( attribute_name.is_a?( Symbol ) ? attribute_value : attribute_value.dup )

    return self

  end

  ###################
  #  get_attribute  #
  ###################

  def get_attribute( object, attribute_name )

    @objects[ object.persistence_id ] ||= { }

    return @objects[ object.persistence_id ][ attribute_name ]

  end

  #######################
  #  delete_attribute!  #
  #######################

  def delete_attribute!( object, attribute_name )
    
    if @objects[ object.persistence_id ]
      @objects[ object.persistence_id ].delete( attribute_name )
    end
    
    return self

  end

  ############
  #  cursor  #
  ############

  def cursor
    return ::Persistence::Adapter::Mock::Cursor.new( self, nil )
  end

  ##################
  #  create_index  #
  ##################

  def create_index( index_name, permits_duplicates )

    index_instance = ::Persistence::Adapter::Mock::Bucket::Index.new( index_name, self, permits_duplicates )
    @indexes[ index_name ] = index_instance
    
    return index_instance
    
  end

  ###########
  #  index  #
  ###########
  
  def index( index_name )
    
    return @indexes[ index_name ]
    
  end
  
  ##################
  #  delete_index  #
  ##################

  def delete_index( index_name )

    return @indexes.delete( index_name )

  end
    
  ################
  #  has_index?  #
  ################
  
  def has_index?( index_name )

    return @indexes.has_key?( index_name )

  end

end
