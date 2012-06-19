
module ::Persistence::Object::Complex::Attributes::AttributesHash

  include ::AccessorUtilities::AccessorMath
  
  ##################
  #  pre_set_hook  #
  ##################
  
  def pre_set_hook( key, value )
    
    case value
      when nil, :reader, :writer, :accessor
      else
        raise ArgumentError, 'Permitted values: :reader, :writer, :accessor.'
    end
    
    return value
    
  end
  
  ###################
  #  post_set_hook  #
  ###################

  def post_set_hook( key, value )
    
    # create method in configuration_instance
    
  end

  #########
  #  add  #
  #########
  
  def add( key, reader_writer_accessor )
    
    # figure out actual addition value
    existing_status = self[ key ]
    
    if actual_status = status_minus_other_status( reader_writer_accessor, existing_status )
    
      # if we have an addition value, do so directly      
      new_status = status_plus_other_status( existing_status, actual_status )

      store_without_hooks( key, new_status )

      # update corresponding structures for addition
      unless @without_hooks
        update_for_addition( key, actual_status )
      end
      
    end
    
    return new_status
          
  end

  #######################
  #  add_without_hooks  #
  #######################
  
  def add_without_hooks( key, reader_writer_accessor )
    
    @without_hooks = true
    
    add( key, reader_writer_accessor )
    
    @without_hooks = false
    
  end

  ##############
  #  subtract  #
  ##############
  
  def subtract( key, reader_writer_accessor )
    
    # figure out actual subtraction value
    existing_status = self[ key ]
    
    result_value = status_minus_other_status( existing_status, reader_writer_accessor )

    if actual_status = status_minus_other_status( reader_writer_accessor, result_value )
    
      # if we have an actual value we are subtracting, do so directly (no hooks)
      if new_status = status_minus_other_status( existing_status, actual_status )
        store_without_hooks( key, new_status )
      elsif existing_status
        delete( key )
      end
      
      # update corresponding structures for subtraction (pass actually-subtracted value)
      unless @without_hooks
        update_for_subtraction( key, actual_status )
      end
      
    end
    
    return result_value
          
  end

  ############################
  #  subtract_without_hooks  #
  ############################
  
  def subtract_without_hooks( key, reader_writer_accessor )

    @without_hooks = true
    
    subtract( key, reader_writer_accessor )
    
    @without_hooks = false

  end

  ############
  #  delete  #
  ############
  
  def delete( key )
    
    object = super( key )
    
    unless @without_hooks
      update_for_subtraction( key, :accessor )
    end
    
    return object
    
  end

  #####################
  #  has_attributes?  #
  #####################
  
  def has_attributes?( *attributes )
    
    has_attributes = false
    
    attributes.each do |this_attribute|
      break unless has_attributes = has_key?( this_attribute )
    end
  
    return has_attributes
    
  end
  
end
