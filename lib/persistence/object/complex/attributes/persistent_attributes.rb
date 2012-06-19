
module ::Persistence::Object::Complex::Attributes::PersistentAttributes

  #####################
  #  default_atomic!  #
  #####################

  def default_atomic!

    @default_atomic = true

  end

  ###################################
  #  default_atomic_without_hooks!  #
  ###################################

  def default_atomic_without_hooks!

    @without_hooks = true
    
    default_atomic!
    
    @without_hooks = false

  end

  #########################
  #  default_non_atomic!  #
  #########################

  def default_non_atomic!

    @default_atomic = false

  end

  #######################################
  #  default_non_atomic_without_hooks!  #
  #######################################

  def default_non_atomic_without_hooks!

    @without_hooks = true
    
    default_non_atomic!
    
    @without_hooks = false

  end

  #####################
  #  default_atomic?  #
  #####################

  def default_atomic?

    return @default_atomic
    
  end

  #########################
  #  default_non_atomic?  #
  #########################
  
  def default_non_atomic?

    return ! @default_atomic
    
  end
  
end
