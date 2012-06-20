
module ::Persistence::Cursor::Interface

  include Enumerable

  ################
  #  initialize  #
  ################
  
  def initialize( bucket_instance )

    @persistence_bucket = bucket_instance

    @adapter_cursor = bucket_instance.adapter_bucket.cursor
    
  end

  ###########
  #  close  #
  ###########

  def close
    
    return @adapter_cursor.close
    
  end

  #############
  #  atomize  #
  #############

  def atomize
    
    extend( ::Persistence::Cursor::Atomic )
    
    return self
    
  end

  ################
  #  persisted?  #
  ################
  
  # [ global_id, ... ]
  def persisted?( *args )

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
  
  def current

    first unless @has_position

    return get_object( @adapter_cursor.current )

  end

  ##########
  #  next  #
  ##########
  
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

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ################
  #  get_object  #
  ################

  def get_object( global_id )

    return @persistence_bucket.get_object( global_id )

  end

end
