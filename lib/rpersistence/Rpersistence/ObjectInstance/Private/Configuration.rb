
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------  Persistence Object Configuration  --------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Configuration

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

  #######################################
  #  Klass::persistence_hash_from_port  #
  #  persistence_hash_from_port         #
  #######################################

  def persistence_hash_from_port( port, global_persistence_id )
    
    object_hash = Hash.new

    if global_persistence_id
  		object_hash   = port.adapter.get_object( global_persistence_id, persistence_bucket )
    end

		return object_hash
		
  end

  ###########################################################
  #  Klass::include_or_extend_for_persistence_if_necessary  #
  #  include_or_extend_for_persistence_if_necessary         #
  ###########################################################

  def include_or_extend_for_persistence_if_necessary

    # we know this object needs to be evaluated as a persistence object
    # for now we are not allowing classes to become enhanced this way
    if self.class == Class
      include( Rpersistence::ObjectInstance::Equality )
    else
      self.extend( Rpersistence::ObjectInstance::Equality )
    end
    
  end

  #################################################
  #  Klass::persistence_object_has_configuration  #
  #  persistence_object_has_configuration         #
  #################################################

  def persistence_object_has_configuration

    has_configuration = false
  
    if  self.class != Class           and 
        ( @__rpersistence__includes__   or
          @__rpersistence__excludes__ )
      has_configuration = true
    end
    
    return has_configuration
    
  end

  #######################################################
  #  Klass::persistence_instance_with_no_configuration  #
  #  persistence_instance_with_no_configuration         #
  #######################################################

  def persistence_instance_with_no_configuration

    has_no_configuration = false
  
    if  self.class != Class             and 
        ! @__rpersistence__includes__   and
        ! @__rpersistence__excludes__
      has_no_configuration = true
    end
    
    return has_no_configuration
    
  end
  
end