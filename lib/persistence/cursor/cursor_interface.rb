
###
# Interface implementation for Cursor class instances.
#
module ::Persistence::Cursor::CursorInterface

  include ::Enumerable

  ################
  #  initialize  #
  ################
  
  ###
  #
  # @param bucket_instance Bucket to use for cursor context.
  # @param index_instance Index to use for cursor context.
  #
  def initialize( bucket_instance, index_instance = nil )

    @persistence_bucket = bucket_instance
    @parent_index = index_instance
    
    # use persistence port, bucket, index, value to instantiate adapter cursor
    if index_instance
      @adapter_cursor = index_instance.adapter_index.cursor
    else
      @adapter_cursor = bucket_instance.adapter_bucket.cursor
    end
    
  end
  
  ###########
  #  close  #
  ###########
  
  ###
  # Declare cursor use complete.
  #
  # @return self
  #
  def close
    
    @adapter_cursor.close
    
    return self
    
  end

  #############
  #  atomize  #
  #############

  ###
  # Enable cursor as atomic cursor, causing objects to be loaded with atomic properties, 
  #   regardless how they are configured.
  #
  # @return self
  #
  def atomize
    
    extend( ::Persistence::Cursor::Atomic )
    
    return self
    
  end

  ################
  #  persisted?  #
  ################
  
  ###
  # Query whether keys are persisted in cursor's current context.
  #
  # @overload persisted?( key, ... )
  #
  #   @param [Object] Key to look up.
  #
  # @return [true,false] Whether key(s) exist in cursor's current context.
  #
  def persisted?( *args )

    # [ global_id, ... ]

    persisted = false

    # args => global_id, ...
    # positions on last id or false if one of ids is not persisted
    if args.count > 0

      args.each do |this_global_id|
        break unless persisted = @adapter_cursor.persisted?( this_global_id )
      end

    # no args
    # positions on first if keys or false if no keys
    else

      persisted = @adapter_cursor.persisted?

    end

    return @has_position = persisted

  end

  #############
  #  persist  #
  #############

  ###
  # Load object with specified persistence ID.
  #
  # @param global_id Object persistence ID for retrieval.
  #
  # @return [Object] Object for persistence ID.
  #
  def persist( global_id )

    object = nil

    if @has_position = @adapter_cursor.persisted?( global_id )
      object = get_object( @adapter_cursor.current )
    end

    return object

  end

  ##########
  #  each  #
  ##########
  
  ###
  # Iterate objects in current cursor context.
  #
  # @yield [object] Current object for cursor context.
  #
  # @yieldparam object Object stored in cursor context.
  #
  def each

    # we have to set position if it's not already set before we can iterate
    first unless @has_position

    return to_enum unless block_given?

    # support for Enumerator#feed - permit a return value
    feed_value = nil

    begin
      while yield_object = self.next
        feed_value = yield( yield_object )
      end
    rescue StopIteration
    end

    return feed_value
    
  end

  ###########
  #  first  #
  ###########
  
  ###
  # Persist first object in cursor context.
  #
  # @param [Integer] first_count How many objects to persist from start of cursor context.
  #
  # @return [Object,Array<Object>] Object or objects requested.
  #
  def first( first_count = 1 )

    objects = nil

    if @has_position = persisted?
      begin
        if first_count == 1
          objects = current
        else
          objects = [ ]
          first_count.times do
            objects.push( self.next )
          end
        end
        # reset to first
        @adapter_cursor.first
      rescue StopIteration
      end
    end

    return objects

  end

  ##########
  #  last  #
  ##########
  
  ###
  # Persist last object in cursor context.
  #
  # @param [Integer] last_count How many objects to persist from end of cursor context.
  #
  # @return [Object,Array<Object>] Object or objects requested.
  #
  def last( last_count = 1 )
    
    objects = nil
    
    if total_count = count
      begin
        first
        skip_records = total_count - last_count
        skip_records.times do
          @adapter_cursor.next
        end
        if last_count == 1
          objects = self.next
        else
          objects = [ ]
          last_count.times do
            objects.push( self.next )
          end
        end
        # reset to first
        @adapter_cursor.first
      rescue StopIteration
      end
    end
    
    return objects
    
  end
  
  #########
  #  any  #
  #########
  
  ###
  # Persist any object in cursor context.
  #
  # @param [Integer] any_count How many objects to persist from cursor context.
  #
  # @return [Object,Array<Object>] Object or objects requested.
  #
  def any( any_count = 1 )
    
    object = nil
    
    if total_count = count
      begin
        @adapter_cursor.first
        objects = [ ]
        any_count.times do
          skip_records = rand( total_count - ( any_count + 1 ) )
          skip_records.times do
            @adapter_cursor.next
          end
          objects.push( self.next )
        end
        objects = objects[ 0 ] if objects.count <= 1
        # reset to first
        @adapter_cursor.first
      rescue StopIteration
      end      
    end
    
    return objects
    
  end

  #############
  #  current  #
  #############
  
  ###
  # Persist current object in cursor context.
  #
  # @return [Object,Array<Object>] Object requested.
  #
  def current

    first unless @has_position

    return get_object( @adapter_cursor.current )

  end

  ##########
  #  next  #
  ##########
  
  ###
  # Return the next object in cursor's current context.
  #
  # @return [Object] Next object in cursor's current context.
  #  
  def next( count = 1 )

    objects = nil

    if count > 1

      objects = [ ]
      count.times do
        objects.push( get_object( @adapter_cursor.next ) )
      end

    else

      objects = get_object( @adapter_cursor.next )

    end

    return objects

  end

  ################
  #  get_object  #
  ################

  ###
  # Get persistence hash for object with specified persistence ID.
  #
  # @param global_id Object persistence ID for retrieval.
  #
  # @return [Hash{String,Symbol=>Object}] Persistence hash of object properties for persistence ID.
  #
  def get_object( global_id )

    return @persistence_bucket.get_object( global_id )

  end

end
