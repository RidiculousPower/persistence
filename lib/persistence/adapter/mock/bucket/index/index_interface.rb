
###
# Interface implementation for Index class instances.
#
module ::Persistence::Adapter::Mock::Bucket::Index::IndexInterface

  ################
  #  initialize  #
  ################
  
  ###
  # 
  # @param index_name 
  # @param parent_bucket 
  # @param permits_duplicates 
  #
  def initialize( index_name, parent_bucket, permits_duplicates )

    @name = index_name

    @keys = { }
    @reverse_keys = { }
    @permits_duplicates = permits_duplicates
    @parent_bucket = parent_bucket

  end

  ###################
  #  parent_bucket  #
  ###################
  
  ###
  # Track parent bucket for this index.
  #
  # @!attribute[r]
  #
  # @return [Persistence::Adapter::Mock::Bucket] Parent bucket instance.
  #
  attr_accessor :parent_bucket

  ############
  #  cursor  #
  ############

  ###
  # Create and return cursor instance for this index.
  #
  # @return [Persistence::Adapter::Mock::Cursor] New cursor instance.
  #
  def cursor
    
    return ::Persistence::Adapter::Mock::Cursor.new( @parent_bucket, self )

  end

  ###########
  #  count  #
  ###########
  
  ###
  # Get the number of indexed objects in this index.
  #
  # @return [Integer] Number of indexed objects in this index.
  #
  def count
    
    return @keys.count
    
  end
  
  #########################
  #  permits_duplicates?  #
  #########################

  ###
  # Reports whether this index permits duplicate indexed entries per key.
  #
  # @return [true,false] Whether index permits duplicate entries.
  #
  def permits_duplicates?
    
    return @permits_duplicates

  end

  #####################
  #  index_object_id  #
  #####################

  ###
  # Index object ID for index key.
  #
  # @param global_id Object persistence ID for object lookup.
  # @param key Key to index for later lookup of object ID in index.
  #
  # @return self
  #
  def index_object_id( global_id, key )

    @keys[ key ] = global_id
    @reverse_keys[ global_id ] = key
    
    return self

  end

  ###################
  #  get_object_id  #
  ###################

  ###
  # Retrieve indexed object ID for index key.
  #
  # @param key Previously indexed key for lookup in index.
  #
  # @return 
  #
  def get_object_id( key )

    return @keys[ key ]
  
  end

  ################################
  #  delete_keys_for_object_id!  #
  ################################

  ###
  # Delete all keys in this index for object ID.
  #
  # @param global_id Object persistence ID for object lookup.
  #
  # @return self
  #
  def delete_keys_for_object_id!( global_id )
    
    index_value_or_keys = @reverse_keys.delete( global_id )

    if index_value_or_keys.is_a?( Array )

      index_value_or_keys.each do |this_key|
        @keys.delete( this_key )
      end

    else

      @keys.delete( index_value_or_keys )

    end
    
    return self
    
  end

end
