
module ::Persistence::Object::Suspend
  
  include ::CascadingConfiguration::Setting
  
  attr_configuration :suspended, :stopped
    
  ###########
  #  stop!  #
  ###########
  
  # suspend atomic writes and quietly suppress explicit calls to persist!
  def stop!

    self.stopped = true

    # if we have a block we stop until the end
    if block_given?
      yield
      resume!
    end

  end

  ##############
  #  suspend!  #
  ##############
  
  # suspend atomic writes and fail explicit calls to persist!
  def suspend!

    self.suspended = true

    # if we have a block we suspend until the end
    if block_given?
      yield
      resume!
    end

  end

  #############
  #  resume!  #
  #############
  
  # resume atomic writes and no longer suppress explicit calls to persist!
  def resume!

    self.suspended = false
    self.stopped = false

  end
  
end
