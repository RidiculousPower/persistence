
###
# Interface implementation for Mock adapter Cursor class instances.
#
module ::Persistence::Adapter::Mock::Cursor::CursorInterface

  ################
  #  initialize  #
  ################

  ###
  # 
  # @param bucket Cursor will open on bucket instance.
  # @param index Cursor will open on index instance.
  #
  def initialize( bucket, index )

    @persistence_bucket = bucket
    @index = index

    @id_source = index  ? index.instance_variable_get( :@keys )
                        : bucket.instance_variable_get( :@objects )
    
    @current_position = ( @id_source || { } ).each

  end
  
  ###########
  #  close  #
  ###########
  
  ###
  # Declare use of cursor complete.
  #
  def close
    
    # nothing required

  end
  
  ################
  #  persisted?  #
  ################
  
  ###
  # Query whether keys are persisted in cursor's current context.
  #   Responsible for setting the cursor position.
  #
  # @overload persisted?( key, ... )
  #
  #   @param [Object] Key to look up.
  #
  # @return [true,false] Whether key(s) exist in cursor's current context.
  #
  def persisted?( *args )

    # persisted? is responsible for setting the cursor position

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
  
  ###
  # Return the first object in cursor's current context.
  #   Responsible for setting the cursor position.
  #
  # @return [Object] First object in cursor's current context.
  #
  def first

    # first should set the cursor position and return the first ID or object hash

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
  
  ###
  # Return the first key in cursor's current context.
  #   Responsible for setting the cursor position.
  #
  # @return [Object] First key in cursor's current context.
  #
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

  ###
  # Return the current object in cursor's current context.
  #
  # @return [Object] Current object in cursor's current context.
  #  
  def current

    # current should return the current ID or object hash

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
  
  ###
  # Return the current key in cursor's current context.
  #
  # @return [Object] Current object in cursor's current context.
  #  
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
  
  ###
  # Return the next object in cursor's current context.
  #
  # @return [Object] Next object in cursor's current context.
  #  
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
  
  ###
  # Return the next key in cursor's current context.
  #
  # @return [Object] Next key in cursor's current context.
  #  
  def next_key
    begin
      @current_item = @current_position.next
    rescue StopIteration
      @current_item = nil
    end
    return current_key
  end

end