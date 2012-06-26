
###
# Module used for common methods for attributes hashes.
#
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
  
  ###
  # Adds :reader, :writer or :accessor to key.
  #
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
  
  ###
  # @private
  #
  # Adds :reader, :writer or :accessor to key.
  #   Used to prevent loops when array/hash relays to other arrays/hashes.
  #
  def add_without_hooks( key, reader_writer_accessor )
    
    @without_hooks = true
    
    add( key, reader_writer_accessor )
    
    @without_hooks = false
    
  end

  ##############
  #  subtract  #
  ##############
  
  ###
  # Subtracts :reader, :writer or :accessor to key.
  #
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
  
  ###
  # @private
  #
  # Subtracts :reader, :writer or :accessor from key.
  #   Used to prevent loops when array/hash relays to other arrays/hashes.
  #
  def subtract_without_hooks( key, reader_writer_accessor )

    @without_hooks = true
    
    subtract( key, reader_writer_accessor )
    
    @without_hooks = false

  end

  ############
  #  delete  #
  ############
  
  ###
  # Deletes attribute and updates corresponding hashes/arrays.
  #
  # @param attribute Attribute to delete.
  #
  # @return [:reader,:writer,:accessor,nil] Setting removed.
  #
  def delete( attribute )
    
    deleted_reader_writer_accessor_setting = super( attribute )
    
    unless @without_hooks
      update_for_subtraction( attribute, :accessor )
    end
    
    return deleted_reader_writer_accessor_setting
    
  end

  #####################
  #  has_attributes?  #
  #####################
  
  ###
  # Query whether this hash includes attribute(s).
  #
  # @overload has_attributes?( attribute_name, ... )
  #
  #     @param attribute_name [Symbol,String] Attribute to query.
  #
  # @return [true,false] Whether this hash/array includes attribute(s).
  #
  def has_attributes?( *attributes )
    
    has_attributes = false
    
    attributes.each do |this_attribute|
      break unless has_attributes = has_key?( this_attribute )
    end
  
    return has_attributes
    
  end
  
end
