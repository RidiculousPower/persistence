
module ::Persistence::Cursor::Indexing::Port::Bucket::Index
  
  include Enumerable
  
  ############
  #  cursor  #
  ############

  def cursor( *args, & block )

    cursor_instance = ::Persistence::Cursor.new( @parent_bucket, self, *args )
    
    if block_given?
      cursor_instance = cursor_instance.instance_eval( & block )
      cursor_instance.close
    end
    
    return cursor_instance
  
  end

  ###################
  #  atomic_cursor  #
  ###################

  def atomic_cursor( *args, & block )
  
    return cursor( *args, & block ).atomize
  
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
      return_value = adapter_index.count
    else
      return_value = super( *args )
    end
    
    return return_value
    
  end

end
