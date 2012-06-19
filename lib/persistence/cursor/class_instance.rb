
module ::Persistence::Cursor::ClassInstance
  
  include Enumerable
  
  ############
  #  cursor  #
  ############

  def cursor( *args, & block )
    
    return instance_persistence_bucket.cursor( *args, & block )
    
  end

  ##########
  #  each  #
  ##########

  def each( & block )
    
    return instance_persistence_bucket.each( & block )
    
  end

  ###########
  #  count  #
  ###########

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

  def persist_first( count = nil )
    
    return instance_persistence_bucket.cursor.first( count )
    
  end

  ##################
  #  persist_last  #
  ##################
  
  def persist_last( count = nil )
    
    return instance_persistence_bucket.cursor.last( count )

  end

  #################
  #  persist_any  #
  #################
  
  def persist_any( count = nil )
    
    return instance_persistence_bucket.cursor.any( count )
    
  end

end
