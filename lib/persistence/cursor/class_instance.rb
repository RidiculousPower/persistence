
###
# Singleton methods providing implicit cursor interfacing for persistence-enabled object types.
#
module ::Persistence::Cursor::ClassInstance
  
  include ::Enumerable
  
  ############
  #  cursor  #
  ############

  ###
  # Create and return cursor instance for this bucket.
  #
  # @return [Persistence::Cursor] New cursor instance.
  #
  def cursor( *args, & block )
    
    return instance_persistence_bucket.cursor( *args, & block )
    
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
  def each( & block )
    
    return instance_persistence_bucket.each( & block )
    
  end

  ###########
  #  count  #
  ###########

  ###
  # Get the number of objects in current cursor context.
  #
  # @return [Integer] Number of objects in current cursor context.
  #
  def count( *args, & block )
    
    return_value = 0

    if block_given?
      return_value = super( & block )
    elsif args.empty?
      return_value = instance_persistence_bucket.count
    else
      return_value = super( *args )
    end
    
    return return_value
    
  end

  ###################
  #  persist_first  #
  ###################
  
  ###
  # Persist first object in cursor context.
  #
  # @param [Integer] count How many objects to persist from start of cursor context.
  #
  # @return [Object,Array<Object>] Object or objects requested.
  #
  def persist_first( count = 1 )
    
    return instance_persistence_bucket.cursor.first( count )
    
  end

  ##################
  #  persist_last  #
  ##################
  
  ###
  # Persist last object in cursor context.
  #
  # @param [Integer] count How many objects to persist from end of cursor context.
  #
  # @return [Object,Array<Object>] Object or objects requested.
  #
  def persist_last( count = 1 )
    
    return instance_persistence_bucket.cursor.last( count )

  end

  #################
  #  persist_any  #
  #################
  
  ###
  # Persist any object in cursor context.
  #
  # @param [Integer] count How many objects to persist from cursor context.
  #
  # @return [Object,Array<Object>] Object or objects requested.
  #
  def persist_any( count = 1 )
    
    return instance_persistence_bucket.cursor.any( count )
    
  end

end
