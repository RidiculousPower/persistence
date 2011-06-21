
#---------------------------------------------------------------------------------------------------------#
#------------------------------------------  Class Objects  ----------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

module Rpersistence::ClassInstance::Persistence

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

  #####################################
  #  Klass.object_for_persistence_id  #
  #####################################
  
  def object_for_persistence_id( port, global_persistence_id )

    object_hash                   = persistence_hash_from_port( port, global_persistence_id )

    object                        = object_from_persistence_hash( port, self, object_hash )

    return object
    
  end

  ########################################
  #  Klass.object_from_persistence_hash  #
  ########################################
  
  def object_from_persistence_hash( port, klass, persistence_ivar_hash )

    object = klass.new
    
    object.instance_eval do
      load_persistence_hash( port, persistence_ivar_hash )
    end
    
    return object

  end

end
