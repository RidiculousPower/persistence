
#-----------------------------------------------------------------------------------------------------------#
#-----------------------------------  Persistence Object Accessors  ----------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Accessors
  
  #########################
  #  Klass.attr_accessor  #
  #  attr_accessor        #
  #########################
  
  def attr_accessor( *attributes )
    persist_atomic = persists_atomic_by_default?
    
    if persist_atomic
      attr_atomic( *attributes )
    else
      super
    end
    return self
  end

  #######################
  #  Klass.attr_reader  #
  #  attr_reader        #
  #######################

  def attr_reader( *attributes )
    if persists_atomic_by_default?
      attr_atomic_reader( *attributes )
    else
      super
    end
    return self
  end

  #######################
  #  Klass.attr_writer  #
  #  attr_writer        #
  #######################

  def attr_writer( *attributes )
    if persists_atomic_by_default?
      attr_atomic_writer( *attributes )
    else
      super
    end
    return self
  end
  
end
