
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------------  Rpersistence Cursor  --------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rpersistence::Cursor

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

	#############
	#  persist  #
	#############

	def object_for_id_or_persistence_hash( current_id_or_hash )

    object = nil

	  # if we have a hash, return object_from_persistence_hash
	  if current_id_or_hash.is_a?( Hash )
	    
	    object = object_from_persistence_hash( current_id_or_hash )
	    
	  # otherwise we have an ID, return @persistence_port.adapter.get_object( global_id, bucket )
    elsif ! current_id_or_hash.nil?
	    
	    object = @persistence_port.adapter.get_object( current_id_or_hash, @persistence_bucket )
	    
    end
    
    return object
    
  end
  
end
