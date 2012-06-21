
###
# Module to enable index instances with cursor capabilities.
#
module ::Persistence::Cursor::Indexing::Port::Bucket::Index
  
  include ::Enumerable
  
  ############
  #  cursor  #
  ############

  ###
  # Create and return cursor instance for this index.
  #
  # @return [Persistence::Cursor] New cursor instance.
  #
  def cursor( *args, & block )

    cursor_instance = ::Persistence::Cursor.new( @parent_bucket, self )
    
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
  def atomic_cursor( *args, & block )
  
    return cursor( *args, & block ).atomize
  
  end

  ##########
  #  each  #
  ##########

  ###
  # Iterate objects in current bucket.
  #
  # @yield [object] Current object.
  #
  # @yieldparam object Object stored in index.
  #
  def each( & block )

    return atomic_cursor.each( & block )

  end

  ###########
  #  count  #
  ###########

  ###
  # Get the number of objects in index.
  #
  # @return [Integer] Number of objects in current cursor context.
  #
  def count( *args, & block )
    
    return_value = 0

    if block_given?
      return_value = super( & block )
    elsif args.empty?
      return_value = adapter_index.count
    else
      return_value = super( *args )
    end
    
    return return_value
    
  end

end
