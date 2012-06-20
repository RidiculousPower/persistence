
module ::Persistence::Cursor::Indexing::Port::Bucket

  ############
  #  cursor  #
  ############

  # allows global_id to set position
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
