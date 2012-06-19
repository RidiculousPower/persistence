
module ::Persistence::Cursor::Port::Bucket

  include Enumerable

  ############
  #  cursor  #
  ############

  # allows global_id to set position
  def cursor( *args, & block )
    
    cursor_instance = ::Persistence::Cursor.new( self, *args )
    
    if block_given?
      cursor_instance = cursor_instance.instance_eval( & block )
      cursor_instance.close
    end
    
    return cursor_instance
  
  end

  ###################
  #  atomic_cursor  #
  ###################

  # allows global_id to set position
  def atomic_cursor( *args )
    
    return cursor( *args ).atomize
  
  end

  ##########
  #  each  #
  ##########

  def each( & block )
    
    return atomic_cursor.each( & block )

  end
  
  ###########
  #  count  #
  ###########

  def count( *args, & block )
    
    return_value = 0

    if block_given?
      return_value = super( & block )
    elsif args.empty?
      return_value = adapter_bucket.count
    else
      return_value = super( *args )
    end
    
    return return_value
    
  end
  
end
