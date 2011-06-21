
#---------------------------------------------------------------------------------------------------------#
#------------------------------------------  Mock Adapter  -----------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

class Rpersistence::Adapter::Mock

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

    ##########################################
    #  ensure_object_has_globally_unique_id  #
    ##########################################
    
    def ensure_object_has_globally_unique_id( object )
    
      unless object.persistence_id

        # in which case we need to create a new ID
         @id_sequence = ( @id_sequence ||= -1 ) + 1
         object.persistence_id = @id_sequence
    
        @bucket_class_for_id[ object.persistence_id ] = [ object.persistence_bucket, object.class ]
      
      end

      return object.persistence_id
    
    end

end
