
###
# Module used for common methods for persistent attributes hash and arrays.
#
module ::Persistence::Object::Complex::Attributes::DefaultAtomicNonAtomic
    
  #####################
  #  default_atomic?  #
  #####################
  
  ###
  # Query whether attributes default to be atomic.
  #
  # @return [true,false] Whether default is atomic.
  #
  def default_atomic?

    return @default_atomic

  end

  #########################
  #  default_non_atomic?  #
  #########################

  ###
  # Query whether attributes default to be non-atomic.
  #
  # @return [true,false] Whether default is non-atomic.
  #
  def default_non_atomic?

    return ! @default_atomic

  end

  #####################
  #  default_atomic!  #
  #####################

  ###
  # Set attributes to default atomic.
  #
  def default_atomic!
    
    @default_atomic = true
    
  end

  ###################################
  #  default_atomic_without_hooks!  #
  ###################################

  ###
  # @private
  #
  # Set attributes to default atomic. 
  #   Used to prevent loops when array/hash relays to other arrays/hashes.
  #
  def default_atomic_without_hooks!

    @without_hooks = true

    default_atomic!

    @without_hooks = false

  end

  #########################
  #  default_non_atomic!  #
  #########################

  ###
  # Set attributes to default non-atomic.
  #
  def default_non_atomic!

    @default_atomic = false

  end

  #######################################
  #  default_non_atomic_without_hooks!  #
  #######################################

  ###
  # @private
  #
  # Set attributes to default non-atomic. Used to prevent loops when array/hash relays to other arrays/hashes.
  #
  def default_non_atomic_without_hooks!

    @without_hooks = true

    default_non_atomic!

    @without_hooks = false

  end
    
end
