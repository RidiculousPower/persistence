
module ::Persistence::Adapter::Mock::Cursor::CursorInterface

  ################
  #  initialize  #
  ################

  def initialize( bucket, index )

    @persistence_bucket = bucket
    @index = index

    @id_source = ( index  ? index.instance_variable_get( :@keys )
                          : bucket.instance_variable_get( :@objects ) )
    
    @current_position = ( @id_source || { } ).each

  end
  
  ###########
  #  close  #
  ###########
  
  def close
    
    # nothing required

  end
  
  #########
  #  get  #
  #########

  def get( index, key )
    @current_position.rewind
    begin
      self.next
    end until current == key
    return current
  end
  
  ################
  #  persisted?  #
  ################

  # persisted? is responsible for setting the cursor position
  def persisted?( *args )

    key = nil
    # we expect 0 or 1 arg
    if args.count > 0
      key = args[ 0 ]
    else
      # if we have no key we are asking if keys exist
      @current_position.rewind

      return @id_source.count > 0 ? true : false
    end

    has_key = false

    # rewind to beginning of bucket
    @current_position.rewind

    # iterate until we find our key
    begin
      
      while @current_item = @current_position.next
        if @current_item[ 0 ] == key
          has_key = true
          break
        end
      end
      
    rescue StopIteration

      @current_item = nil

    end

    return has_key

  end

  ###########
  #  first  #
  ###########
  
  # first should set the cursor position and return the first ID or object hash
  def first
    begin
      @current_item = @current_position.rewind.peek
    rescue StopIteration
      @current_item = nil
    end
    return current
  end

  ###############
  #  first_key  #
  ###############
  
  def first_key
    begin
      @current_item = @current_position.rewind.peek
    rescue StopIteration
      @current_item = nil
    end
    return current_key
  end

  #############
  #  current  #
  #############
  
  # current should return the current ID or object hash
  def current
    current_id = nil
    if @current_item
      if @index
        current_id = @current_item[ 1 ]
      else
        current_id = @current_item[ 0 ]
      end
    end
    return current_id
  end

  #################
  #  current_key  #
  #################
  
  def current_key
    current_key = nil
    if @current_item
      current_key = @current_item[ 0 ]
    end
    return current_key
  end

  ##########
  #  next  #
  ##########
  
  def next
    begin
      @current_item = @current_position.next
    rescue StopIteration
      @current_item = nil
    end
    return current
  end

  ##############
  #  next_key  #
  ##############
  
  def next_key
    begin
      @current_item = @current_position.next
    rescue StopIteration
      @current_item = nil
    end
    return current_key
  end

end