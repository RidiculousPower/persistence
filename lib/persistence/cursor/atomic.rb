
###
# Cursor subclass that automatically performs atomic lookups on attributes. 
#
module ::Persistence::Cursor::Atomic

  ################
  #  get_object  #
  ################

  ###
  # Get object for persistence ID using atomic attribute loading, regardless how attributes are declared.
  #
  # @param global_id Persistence ID to retrieve object.
  #
  # @return [Object] Object being retrieved for persistence ID.
  #
  def get_object( global_id )
    
    klass = @persistence_bucket.parent_port.get_class_for_object_id( global_id )
    
    object = nil
    
    if klass
      object = klass.new
      object.persistence_id = global_id
      object.attrs_atomic!
    end
    
    return object

  end

  #############
  #  persist  #
  #############

  ###
  # Load object with specified persistence ID.
  #
  # @param key Key to retrieve.
  #
  # @return [Object] Object for persistence ID.
  #
  def persist( key )
    
    return super.attr_atomic!

  end

  ###########
  #  first  #
  ###########
  
  ###
  # Persist first object in cursor context.
  #
  # @param [Integer] count How many objects to persist from start of cursor context.
  #
  # @return [Object,Array<Object>] Object or objects requested.
  #
  def first( count = 1 )
    first_values = super
    if first_values.is_a?( Array )
      first_values.each do |this_value|
        this_value.attr_atomic!
      end
    elsif first_values
      first_values.attr_atomic!
    end
    return first_values
  end

  #############
  #  current  #
  #############
  
  ###
  # Persist current object in cursor context.
  #
  # @return [Object,Array<Object>] Object requested.
  #
  def current
    current_value = super
    current_value.attr_atomic! if current_value
    return current_value
  end

  ##########
  #  next  #
  ##########
  
  ###
  # Return the next object in cursor's current context.
  #
  # @return [Object] Next object in cursor's current context.
  #  
  def next( count = 1 )
    next_values = super
    if next_values.is_a?( Array )
      next_values.each do |this_value|
        this_value.attr_atomic!
      end
    elsif next_values
      next_values.attr_atomic!
    end
    return next_values
  end

end
