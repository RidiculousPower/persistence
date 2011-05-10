
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
    
    attributes.each do |this_attribute|
      if persist_atomic and ! non_persistent_attribute_accessor?( this_attribute ) and ! non_atomic_attribute_accessor?( this_attribute )
        attr_atomic( this_attribute )
      else
        super
      end
    end
  
    return self

  end

  #######################
  #  Klass.attr_reader  #
  #  attr_reader        #
  #######################

  def attr_reader( *attributes )
  
    persist_atomic = persists_atomic_by_default?
    
    attributes.each do |this_attribute|
      if persist_atomic and ! non_persistent_attribute_reader?( this_attribute ) and ! non_atomic_attribute_reader?( this_attribute )
        attr_atomic_reader( this_attribute )
      else
        super
      end
    end
  
    return self

  end

  #######################
  #  Klass.attr_writer  #
  #  attr_writer        #
  #######################

  def attr_writer( *attributes )

    persist_atomic = persists_atomic_by_default?
    
    attributes.each do |this_attribute|
      if persist_atomic and ! non_persistent_attribute_writer?( this_attribute ) and ! non_atomic_attribute_writer?( this_attribute )
        attr_atomic_writer( this_attribute )
      else
        super
      end
    end
  
    return self

  end
  
end
