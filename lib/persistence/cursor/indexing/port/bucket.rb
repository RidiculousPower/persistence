
###
# Module to enable bucket instances with indexed cursor capabilities.
#
module ::Persistence::Cursor::Indexing::Port::Bucket

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

end
